import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:nonogram/ads/ad_service.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/core/onboarding_preferences.dart';
import 'package:nonogram/data/nonogram_puzzle_source.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_event.dart';
import 'package:nonogram/screens/play/coach/nonogram_play_coach.dart';
import 'package:nonogram/screens/play/engine/nonogram_board_layout.dart';
import 'package:nonogram/screens/play/nonogram_play_page.dart';
import 'package:nonogram/screens/play/nonogram_transformation_controller_provider.dart';
import 'package:nonogram/screens/play/sections/nonogram_board_shell_section.dart';
import 'package:nonogram/screens/play/sections/nonogram_board_viewport.dart';
import 'package:nonogram/screens/play/views/wand_action.dart';
import 'package:nonogram/screens/play/widgets/overlay_button.dart';
import 'package:nonogram/screens/play/sections/nonogram_landscape_info_panel.dart';

import '../mocks/fake_ad_service.dart';
import '../mocks/fake_nonogram_local_service.dart';

/// Một màn 40x40 hàng/cột xen kẽ (20 gợi ý mỗi hàng/cột), đủ lớn để phải
/// kéo bàn và để dải gợi ý bị cắt.
class _BigPuzzleSource implements NonogramPuzzleSource {
  @override
  Future<int> totalLevels() async => 1;

  @override
  Future<NonogramPuzzle?> puzzleByLevel(int level) async {
    if (level != 1) return null;
    return NonogramPuzzle(
      id: 'big',
      title: 'Big',
      author: '',
      difficulty: '',
      difficultyScore: 0,
      level: 1,
      solution: List.generate(40, (r) => List.generate(40, (c) => (r + c) % 2)),
    );
  }
}

Future<void> _pumpPlay(
  WidgetTester tester,
  Size size, {
  OnboardingPreferences? onboarding,
  AdService? ads,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NonogramRepository>.value(
          value: NonogramRepository(
            _BigPuzzleSource(),
            FakeNonogramLocalService(),
          ),
        ),
        ChangeNotifierProvider.value(value: AppThemeModeController.inMemory()),
        if (onboarding != null) Provider.value(value: onboarding),
        if (ads != null) Provider<AdService>.value(value: ads),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const NonogramPlayPage(),
      ),
    ),
  );
  // Tải màn, đo khung nhìn, tự co cỡ ô, đặt vị trí mở màn.
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Offset _gridOffset(WidgetTester tester) {
  final element = tester.element(find.byType(NonogramBoardViewport));
  final t =
      NonogramTransformationControllerProvider.of(
        element,
      ).value.getTranslation();
  return Offset(t.x, t.y);
}

NonogramPlayBloc _bloc(WidgetTester tester) =>
    tester.element(find.byType(NonogramBoardViewport)).read<NonogramPlayBloc>();

int _filledCount(WidgetTester tester) =>
    _bloc(tester).state.gridData
        .expand((r) => r)
        .where((c) => c == NonogramCellState.filled)
        .length;

/// Toạ độ toàn cục của góc trên-trái bàn chơi.
Offset _boardOrigin(WidgetTester tester) =>
    tester.getTopLeft(find.byType(NonogramBoardViewport));

void main() {
  const phone = Size(412, 860);

  testWidgets('one finger on the left clue strip scrolls the board', (
    tester,
  ) async {
    await _pumpPlay(tester, phone);
    final before = _gridOffset(tester);
    final origin = _boardOrigin(tester);

    // Điểm trên dải trái, ngang hàng thứ 3 của lưới.
    final cell = _bloc(tester).state.cellSize;
    final start = origin + Offset(before.dx - 10, before.dy + cell * 2.5);
    final gesture = await tester.startGesture(start);
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(0, -20));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 50));

    final after = _gridOffset(tester);
    expect(after.dy, lessThan(before.dy - 100));
    expect(_filledCount(tester), 0);
  });

  testWidgets('drawing into the bottom edge auto-scrolls and keeps filling', (
    tester,
  ) async {
    await _pumpPlay(tester, phone);
    final before = _gridOffset(tester);
    final origin = _boardOrigin(tester);
    final viewportSize = tester.getSize(find.byType(NonogramBoardViewport));
    final cell = _bloc(tester).state.cellSize;

    final x = before.dx + cell * 2.5;
    final gesture = await tester.startGesture(
      origin + Offset(x, before.dy + cell * 0.5),
    );
    // Kéo thẳng xuống tới sát mép dưới rồi giữ yên.
    final target = viewportSize.height - 10;
    var y = before.dy + cell * 0.5;
    while (y < target) {
      final step = (target - y).clamp(0.0, 30.0);
      y += step;
      await gesture.moveTo(origin + Offset(x, y));
      await tester.pump(const Duration(milliseconds: 16));
    }
    final filledAtEdge = _filledCount(tester);
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 50));

    expect(_gridOffset(tester).dy, lessThan(before.dy - 50));
    expect(_filledCount(tester), greaterThan(filledAtEdge));
  });

  testWidgets('Fill / X toggle switches what a tap does', (tester) async {
    await _pumpPlay(tester, phone);
    final t = _gridOffset(tester);
    final origin = _boardOrigin(tester);
    final cell = _bloc(tester).state.cellSize;
    final target = origin + t + Offset(cell * 1.5, cell * 1.5);

    await tester.tap(find.byKey(const ValueKey('nonogram-mode-mark')));
    await tester.pump(const Duration(milliseconds: 50));
    expect(_bloc(tester).state.interactionMode, NonogramInteractionMode.mark);

    await tester.tapAt(target);
    await tester.pump(const Duration(milliseconds: 400));
    expect(_bloc(tester).state.gridData[1][1], NonogramCellState.marked);

    await tester.tap(find.byKey(const ValueKey('nonogram-mode-fill')));
    await tester.pump(const Duration(milliseconds: 50));
    expect(_bloc(tester).state.interactionMode, NonogramInteractionMode.fill);

    // Chạm lại vào bên đang bật cũng chuyển sang chế độ còn lại.
    await tester.tap(find.byKey(const ValueKey('nonogram-mode-fill')));
    await tester.pump(const Duration(milliseconds: 50));
    expect(_bloc(tester).state.interactionMode, NonogramInteractionMode.mark);
    await tester.tap(find.byKey(const ValueKey('nonogram-mode-mark')));
    await tester.pump(const Duration(milliseconds: 50));
    expect(_bloc(tester).state.interactionMode, NonogramInteractionMode.fill);

    await tester.tapAt(target + Offset(cell, 0));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_bloc(tester).state.gridData[1][2], NonogramCellState.filled);
  });

  testWidgets('restarting the level asks for confirmation first', (
    tester,
  ) async {
    await _pumpPlay(tester, phone);
    final t = _gridOffset(tester);
    final origin = _boardOrigin(tester);
    final cell = _bloc(tester).state.cellSize;
    await tester.tapAt(origin + t + Offset(cell * 0.5, cell * 0.5));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_filledCount(tester), 1);

    // Không còn nút xoá trên thanh công cụ.
    expect(find.byIcon(LucideIcons.eraser), findsNothing);

    await tester.tap(find.byIcon(LucideIcons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nonogram-restart')));
    await tester.pumpAndSettle();

    // Huỷ: bàn giữ nguyên.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(_filledCount(tester), 1);

    await tester.tap(find.byKey(const ValueKey('nonogram-restart')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nonogram-restart-confirm')));
    await tester.pumpAndSettle();
    expect(_filledCount(tester), 0);
  });

  testWidgets('landscape drops the app bar and uses a side rail', (
    tester,
  ) async {
    await _pumpPlay(tester, const Size(900, 400));
    expect(find.byType(AppBar), findsNothing);
    expect(find.byIcon(LucideIcons.arrowLeft), findsOneWidget);
    expect(find.byIcon(LucideIcons.settings), findsOneWidget);
    // Màn ngang tự toàn màn hình: không có nút toàn màn hình.
    expect(find.byIcon(LucideIcons.maximize2), findsNothing);
    expect(find.byKey(const ValueKey('nonogram-mode-mark')), findsOneWidget);

    // Không còn chừa 64px phía trên: dải gợi ý trên bắt đầu sát mép.
    final t = _gridOffset(tester);
    expect(t.dy, lessThan(400 * 0.30 + 1));
  });

  testWidgets('landscape shows level info that can be hidden', (tester) async {
    LandscapeInfoPanelVisibility.notifier.value = true;
    addTearDown(() => LandscapeInfoPanelVisibility.notifier.value = true);

    await _pumpPlay(tester, const Size(900, 400));
    const panel = ValueKey('nonogram-landscape-info-panel');
    expect(find.byKey(panel), findsOneWidget);
    expect(find.text('Big'), findsOneWidget);
    expect(find.text('40 × 40'), findsOneWidget);
    // Cột trái nới theo bảng để bảng không che bàn chơi.
    expect(_boardOrigin(tester).dx, NonogramLandscapeLeftRail.panelWidth);

    await tester.tap(
      find.byKey(const ValueKey('nonogram-landscape-info-hide')),
    );
    // Trượt bảng vào (220ms) rồi mới thu cột về bề rộng cột nút.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byKey(panel), findsNothing);
    expect(_boardOrigin(tester).dx, NonogramBoardLayout.railReserve);

    await tester.tap(find.byKey(const ValueKey('nonogram-landscape-info')));
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byKey(panel), findsOneWidget);
    expect(_boardOrigin(tester).dx, NonogramLandscapeLeftRail.panelWidth);
  });

  testWidgets('landscape: menu on the left, game actions on the right', (
    tester,
  ) async {
    await _pumpPlay(tester, const Size(900, 400));
    Offset at(Finder finder) => tester.getCenter(finder);

    final back = at(find.byIcon(LucideIcons.arrowLeft));
    final info = at(find.byKey(const ValueKey('nonogram-landscape-info')));
    final rotate = at(find.byKey(const ValueKey('nonogram-rotate-screen')));
    final settings = at(find.byIcon(LucideIcons.settings));
    final hint = at(find.byIcon(LucideIcons.lightbulb));
    final mark = at(find.byKey(const ValueKey('nonogram-mode-mark')));

    // Cột trái: quay lại, thông tin ở góc trên; xoay, cài đặt ở góc dưới.
    for (final p in [back, info, rotate, settings]) {
      expect(p.dx, lessThan(NonogramBoardLayout.railReserve));
    }
    expect(back.dy, lessThan(info.dy));
    expect(info.dy, lessThan(400 / 2));
    expect(rotate.dy, greaterThan(400 / 2));
    expect(rotate.dy, lessThan(settings.dy));

    // Mép phải chỉ còn gợi ý, gậy phép, hoàn tác và Tô / X (theo thứ tự
    // đó), ở góc trên.
    final wand = at(find.byKey(const ValueKey('nonogram-wand')));
    for (final p in [hint, wand, mark]) {
      expect(p.dx, greaterThan(900 - NonogramBoardLayout.railReserve));
    }
    final hintButton = find.byIcon(LucideIcons.lightbulb);
    expect(tester.getCenter(hintButton).dy, closeTo(back.dy, 4));
    expect(hint.dy, lessThan(wand.dy));
    // Hoàn tác giữa gậy phép và cụm Tô / X.
    final undo = at(find.byKey(const ValueKey('nonogram-undo')));
    expect(undo.dx, greaterThan(900 - NonogramBoardLayout.railReserve));
    expect(wand.dy, lessThan(undo.dy));
    expect(undo.dy, lessThan(mark.dy));
  });

  testWidgets('landscape controls guide: cards beside their target, all steps '
      'shown', (tester) async {
    final prefs = OnboardingPreferences.inMemory(
      playCoachSeen: true,
      scrollTipSeen: true,
    );
    // Điện thoại nằm ngang: thấp, thẻ không vừa phía trên / dưới nút nào.
    await _pumpPlay(tester, const Size(1000, 450), onboarding: prefs);
    await tester.tap(find.byIcon(LucideIcons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nonogram-controls-guide')));
    await tester.pumpAndSettle();

    final card = find.byKey(const ValueKey('nonogram-coach-card'));
    void expectBeside(Finder target) {
      final c = tester.getRect(card);
      final t = tester.getRect(target);
      expect(c.overlaps(t), isFalse, reason: 'card $c covers target $t');
    }

    final buttons = <int, Finder>{
      1: find.byIcon(LucideIcons.lightbulb),
      2: find.byKey(const ValueKey('nonogram-wand')),
      3: find.byKey(const ValueKey('nonogram-mode-mark')),
      6: find.byKey(const ValueKey('nonogram-rotate-screen')),
    };
    for (var step = 1; step <= 7; step++) {
      expect(find.text('$step/7'), findsOneWidget);
      expect(tester.takeException(), isNull);
      final target = buttons[step];
      if (target != null) expectBeside(target.first);
      await tester.tap(find.byKey(const ValueKey('nonogram-coach-next')));
      await tester.pumpAndSettle();
    }
    expect(card, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pinching with two fingers pans but never changes cell size', (
    tester,
  ) async {
    await _pumpPlay(tester, phone);
    final cellBefore = _bloc(tester).state.cellSize;
    final before = _gridOffset(tester);
    final origin = _boardOrigin(tester);
    final center = origin + before + Offset(cellBefore * 4, cellBefore * 4);

    final a = await tester.startGesture(center - const Offset(30, 0));
    final b = await tester.startGesture(
      center + const Offset(30, 0),
      pointer: 9,
    );
    for (var i = 0; i < 10; i++) {
      // Hai ngón tách ra (chụm phóng to) và cùng trôi lên trên-trái.
      await a.moveBy(const Offset(-12, -10));
      await b.moveBy(const Offset(8, -10));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await a.up();
    await b.up();
    await tester.pump(const Duration(milliseconds: 50));

    expect(_bloc(tester).state.cellSize, cellBefore);
    expect(_gridOffset(tester).dy, lessThan(before.dy - 50));
    expect(_filledCount(tester), 0);
  });

  testWidgets('rotate button locks the other orientation', (tester) async {
    final calls = <List<Object?>>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemChrome.setPreferredOrientations') {
          calls.add(List<Object?>.from(call.arguments as List));
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await _pumpPlay(tester, phone);
    await tester.tap(find.byKey(const ValueKey('nonogram-rotate-screen')));
    await tester.pump();
    expect(calls.last, [
      'DeviceOrientation.landscapeLeft',
      'DeviceOrientation.landscapeRight',
    ]);

    await _pumpPlay(tester, const Size(900, 400));
    await tester.tap(find.byKey(const ValueKey('nonogram-rotate-screen')));
    await tester.pump();
    expect(calls.last, ['DeviceOrientation.portraitUp']);
  });

  testWidgets('magic wand reveals the row whose clues are tapped', (
    tester,
  ) async {
    await _pumpPlay(tester, phone);
    final bloc = _bloc(tester);
    final origin = _boardOrigin(tester);
    final offset = _gridOffset(tester);
    final cell = bloc.state.cellSize;

    await tester.tap(find.byKey(const ValueKey('nonogram-wand')));
    await tester.pump();
    expect(bloc.state.isWandActive, isTrue);
    expect(find.byKey(const ValueKey('nonogram-wand-cancel')), findsOneWidget);

    // Đang chọn: chạm vào ô lưới không tô.
    await tester.tapAt(origin + offset + Offset(cell * 0.5, cell * 0.5));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_filledCount(tester), 0);
    expect(bloc.state.isWandActive, isTrue);

    // Chạm vào dải số trái, ngang hàng thứ 3.
    await tester.tapAt(origin + Offset(offset.dx - 10, offset.dy + cell * 2.5));
    await tester.pump(const Duration(milliseconds: 400));

    expect(bloc.state.remainingWands, 0);
    expect(bloc.state.isWandActive, isFalse);
    final row = bloc.state.gridData[2];
    for (var c = 0; c < row.length; c++) {
      expect(
        row[c],
        (2 + c) % 2 == 1 ? NonogramCellState.filled : NonogramCellState.marked,
      );
    }
    expect(_filledCount(tester), 20);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('cancel leaves wand mode without using it', (tester) async {
    await _pumpPlay(tester, phone);
    await tester.tap(find.byKey(const ValueKey('nonogram-wand')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('nonogram-wand-cancel')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(_bloc(tester).state.isWandActive, isFalse);
    expect(_bloc(tester).state.remainingWands, 1);
  });

  testWidgets('other actions are blocked while choosing a wand line', (
    tester,
  ) async {
    await _pumpPlay(tester, phone);
    final bloc = _bloc(tester);
    final hints = bloc.state.remainingHints;
    final mode = bloc.state.interactionMode;
    await tester.tap(find.byKey(const ValueKey('nonogram-wand')));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(LucideIcons.lightbulb));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const ValueKey('nonogram-mode-mark')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(bloc.state.isWandActive, isTrue);
    expect(bloc.state.remainingHints, hints);
    expect(bloc.state.interactionMode, mode);

    await tester.tap(find.byKey(const ValueKey('nonogram-wand-cancel')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(bloc.state.isWandActive, isFalse);
  });

  /// Dùng hết lượt gậy phép (hiện đáp án hàng thứ 3).
  Future<void> useUpWand(WidgetTester tester) async {
    final bloc = _bloc(tester);
    bloc.add(const WandToggled());
    bloc.add(
      const WandLineSelected(isRow: true, index: 2, offsetX: 0, offsetY: 0),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(bloc.state.remainingWands, 0);
  }

  testWidgets('empty wand shows an ad badge and plays an ad at once', (
    tester,
  ) async {
    final ads = FakeAdService();
    await _pumpPlay(tester, phone, ads: ads);
    await useUpWand(tester);
    final wand = find.byKey(const ValueKey('nonogram-wand'));
    expect(
      find.descendant(
        of: find.ancestor(of: wand, matching: find.byType(Stack)).first,
        matching: find.byIcon(LucideIcons.video),
      ),
      findsOneWidget,
    );

    await tester.tap(wand);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Không có hộp thoại hỏi: quảng cáo phát ngay, xem xong vào chế độ chọn.
    expect(ads.rewardedShown, [AdPlacement.wandRefill]);
    expect(_bloc(tester).state.isWandActive, isTrue);
    expect(_bloc(tester).state.remainingWands, 1);
  });

  testWidgets('closing the ad early gives no wand', (tester) async {
    final ads = FakeAdService(earnReward: false);
    await _pumpPlay(tester, phone, ads: ads);
    await useUpWand(tester);

    await tester.tap(find.byKey(const ValueKey('nonogram-wand')));
    await tester.pumpAndSettle();
    expect(ads.rewardedShown, hasLength(1));
    expect(_bloc(tester).state.isWandActive, isFalse);
    expect(_bloc(tester).state.remainingWands, 0);
  });

  testWidgets('no ad loaded yet: nothing is granted', (tester) async {
    final ads = FakeAdService(ready: false);
    await _pumpPlay(tester, phone, ads: ads);
    await useUpWand(tester);

    await tester.tap(find.byKey(const ValueKey('nonogram-wand')));
    await tester.pumpAndSettle();
    expect(ads.rewardedShown, isEmpty);
    expect(_bloc(tester).state.isWandActive, isFalse);
  });

  testWidgets('builds without ads (web) give an empty wand for free', (
    tester,
  ) async {
    await _pumpPlay(tester, phone);
    await useUpWand(tester);
    await tester.tap(find.byKey(const ValueKey('nonogram-wand')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(_bloc(tester).state.isWandActive, isTrue);
  });

  testWidgets('empty hint plays an ad and opens a hint without storing it', (
    tester,
  ) async {
    final ads = FakeAdService();
    await _pumpPlay(tester, phone, ads: ads);
    final bloc = _bloc(tester);
    for (var i = 0; i < 3; i++) {
      bloc.add(const HintRequested(offsetX: 0, offsetY: 0));
    }
    await tester.pump(const Duration(milliseconds: 400));
    expect(bloc.state.remainingHints, 0);
    final filled = _filledCount(tester);

    await tester.tap(find.byIcon(LucideIcons.lightbulb));
    await tester.pumpAndSettle();
    expect(ads.rewardedShown, [AdPlacement.hintRefill]);
    expect(_filledCount(tester), filled + 5);
    expect(bloc.state.remainingHints, 0);
  });

  testWidgets('settings show ad privacy only when it is required', (
    tester,
  ) async {
    final ads = FakeAdService();
    await _pumpPlay(tester, phone, ads: ads);
    await tester.tap(find.byIcon(LucideIcons.settings));
    await tester.pumpAndSettle();
    final privacy = find.byKey(const ValueKey('nonogram-ad-privacy'));
    expect(privacy, findsNothing);

    ads.privacyRequired = true;
    await tester.pump();
    await tester.ensureVisible(privacy);
    await tester.tap(privacy);
    await tester.pumpAndSettle();
    expect(ads.privacyShown, 1);
  });

  testWidgets('first game shows the controls guide once, scroll tip included', (
    tester,
  ) async {
    final prefs = OnboardingPreferences.inMemory();
    await _pumpPlay(tester, phone, onboarding: prefs);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(NonogramPlayCoachOverlay), findsOneWidget);
    expect(find.text('Hint'), findsOneWidget);
    expect(find.text('1/7'), findsOneWidget);
    expect(prefs.playCoachSeen, isTrue);
    expect(prefs.scrollTipSeen, isTrue);

    // Lớp phủ chặn thao tác bên dưới: chạm = sang bước tiếp.
    await tester.tap(find.byKey(const ValueKey('nonogram-coach-next')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('2/7'), findsOneWidget);
    expect(find.text('Magic wand'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('nonogram-coach-skip')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(NonogramPlayCoachOverlay), findsNothing);
    expect(_filledCount(tester), 0);
  });

  testWidgets('controls guide is not shown again once seen', (tester) async {
    final prefs = OnboardingPreferences.inMemory(
      playCoachSeen: true,
      scrollTipSeen: true,
    );
    await _pumpPlay(tester, phone, onboarding: prefs);
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(NonogramPlayCoachOverlay), findsNothing);
  });

  testWidgets('settings can replay the controls guide', (tester) async {
    final prefs = OnboardingPreferences.inMemory(
      playCoachSeen: true,
      scrollTipSeen: true,
    );
    await _pumpPlay(tester, phone, onboarding: prefs);
    await tester.tap(find.byIcon(LucideIcons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nonogram-controls-guide')));
    await tester.pumpAndSettle();

    expect(find.byType(NonogramPlayCoachOverlay), findsOneWidget);
    for (var i = 0; i < 7; i++) {
      await tester.tap(find.byKey(const ValueKey('nonogram-coach-next')));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(find.byType(NonogramPlayCoachOverlay), findsNothing);
  });

  group('drag tip', () {
    Offset cellAt(WidgetTester tester, int row, int col) {
      final origin = _boardOrigin(tester);
      final offset = _gridOffset(tester);
      final size = _bloc(tester).state.cellSize;
      return origin +
          Offset(
            offset.dx + (col + 0.5) * size,
            offset.dy + (row + 0.5) * size,
          );
    }

    final tip = find.byKey(const ValueKey('nonogram-drag-tip'));

    Future<void> tapCells(WidgetTester tester, int count) async {
      for (var c = 0; c < count; c++) {
        await tester.tapAt(cellAt(tester, 0, c));
        await tester.pump(const Duration(milliseconds: 400));
      }
    }

    testWidgets('shows after 3 single taps, "Got it" hides it for good', (
      tester,
    ) async {
      final prefs = OnboardingPreferences.inMemory(
        playCoachSeen: true,
        scrollTipSeen: true,
      );
      await _pumpPlay(tester, phone, onboarding: prefs);
      await tapCells(tester, 2);
      expect(tip, findsNothing);
      await tapCells(tester, 1);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tip, findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('nonogram-drag-tip-ok')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tip, findsNothing);
      expect(prefs.dragTipSeen, isTrue);
    });

    testWidgets('dragging across squares means no tip', (tester) async {
      final prefs = OnboardingPreferences.inMemory(
        playCoachSeen: true,
        scrollTipSeen: true,
      );
      await _pumpPlay(tester, phone, onboarding: prefs);
      final size = _bloc(tester).state.cellSize;
      final gesture = await tester.startGesture(cellAt(tester, 2, 0));
      for (var i = 0; i < 3; i++) {
        await gesture.moveBy(Offset(size, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 50));
      expect(prefs.dragTipSeen, isTrue);
      await tapCells(tester, 3);
      expect(tip, findsNothing);
    });

    testWidgets('not shown to players who already know', (tester) async {
      final prefs = OnboardingPreferences.inMemory(
        playCoachSeen: true,
        scrollTipSeen: true,
        dragTipSeen: true,
      );
      await _pumpPlay(tester, phone, onboarding: prefs);
      await tapCells(tester, 4);
      expect(tip, findsNothing);
    });
  });

  group('undo', () {
    Offset cellAt(WidgetTester tester, int row, int col) {
      final origin = _boardOrigin(tester);
      final offset = _gridOffset(tester);
      final size = _bloc(tester).state.cellSize;
      return origin +
          Offset(
            offset.dx + (col + 0.5) * size,
            offset.dy + (row + 0.5) * size,
          );
    }

    OverlayButton undoButton(WidgetTester tester) => tester
        .widget<OverlayButton>(find.byKey(const ValueKey('nonogram-undo')));

    Future<void> tapUndo(WidgetTester tester) async {
      await tester.tap(find.byKey(const ValueKey('nonogram-undo')));
      await tester.pump(const Duration(milliseconds: 50));
    }

    testWidgets('disabled until something changes; one tap = one step', (
      tester,
    ) async {
      await _pumpPlay(tester, phone);
      expect(undoButton(tester).enabled, isFalse);

      await tester.tapAt(cellAt(tester, 0, 0));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tapAt(cellAt(tester, 0, 1));
      await tester.pump(const Duration(milliseconds: 400));
      expect(_filledCount(tester), 2);
      expect(undoButton(tester).enabled, isTrue);

      await tapUndo(tester);
      expect(_filledCount(tester), 1);
      expect(_bloc(tester).state.gridData[0][1], NonogramCellState.empty);
      await tapUndo(tester);
      expect(_filledCount(tester), 0);
      expect(undoButton(tester).enabled, isFalse);
    });

    testWidgets('a whole drag is undone in one step', (tester) async {
      await _pumpPlay(tester, phone);
      final size = _bloc(tester).state.cellSize;
      final gesture = await tester.startGesture(cellAt(tester, 1, 0));
      for (var i = 0; i < 4; i++) {
        await gesture.moveBy(Offset(size, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 50));
      expect(_filledCount(tester), greaterThanOrEqualTo(4));

      await tapUndo(tester);
      expect(_filledCount(tester), 0);
      expect(undoButton(tester).enabled, isFalse);
    });

    testWidgets('cells opened by a hint stay after undo', (tester) async {
      await _pumpPlay(tester, phone);
      final bloc = _bloc(tester);
      await tester.tapAt(cellAt(tester, 0, 0));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.byIcon(LucideIcons.lightbulb));
      await tester.pump(const Duration(milliseconds: 600));
      final locked = {...bloc.state.lockedCells};
      expect(locked, isNotEmpty);

      await tapUndo(tester);
      for (final c in locked) {
        expect(bloc.state.isLocked(c.row, c.col), isTrue);
        expect(
          bloc.state.gridData[c.row][c.col],
          isNot(NonogramCellState.empty),
        );
      }
    });

    testWidgets('restarting the level clears the undo history', (tester) async {
      await _pumpPlay(tester, phone);
      await tester.tapAt(cellAt(tester, 0, 0));
      await tester.pump(const Duration(milliseconds: 400));
      expect(undoButton(tester).enabled, isTrue);
      _bloc(tester).add(const BoardReset(offsetX: 0, offsetY: 0));
      await tester.pump(const Duration(milliseconds: 50));
      expect(undoButton(tester).enabled, isFalse);
    });
  });

  testWidgets('settings no longer list the licenses', (tester) async {
    await _pumpPlay(tester, phone);
    await tester.tap(find.byIcon(LucideIcons.settings));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('nonogram-licenses')), findsNothing);
  });

  testWidgets('the controls guide has a step about dragging', (tester) async {
    final prefs = OnboardingPreferences.inMemory(
      playCoachSeen: true,
      scrollTipSeen: true,
    );
    await _pumpPlay(tester, phone, onboarding: prefs);
    await tester.tap(find.byIcon(LucideIcons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nonogram-controls-guide')));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const ValueKey('nonogram-coach-next')));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(find.text('4/7'), findsOneWidget);
    expect(find.text('Drag to fill many squares'), findsOneWidget);
  });

  testWidgets('cells opened by the wand cannot be changed', (tester) async {
    await _pumpPlay(tester, phone);
    final bloc = _bloc(tester);
    final origin = _boardOrigin(tester);
    final offset = _gridOffset(tester);
    final cell = bloc.state.cellSize;

    await tester.tap(find.byKey(const ValueKey('nonogram-wand')));
    await tester.pump();
    await tester.tapAt(origin + Offset(offset.dx - 10, offset.dy + cell * 2.5));
    await tester.pump(const Duration(milliseconds: 400));
    expect(bloc.state.isLocked(2, 0), isTrue);
    final row = List.of(bloc.state.gridData[2]);

    // Chạm, nhấn giữ vào ô khoá: không đổi.
    final p0 = origin + offset + Offset(cell * 0.5, cell * 2.5);
    final p1 = origin + offset + Offset(cell * 1.5, cell * 2.5);
    await tester.tapAt(p0);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tapAt(p1);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.longPressAt(p0);
    await tester.pump(const Duration(milliseconds: 400));
    expect(bloc.state.gridData[2], row);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('count badges are not clipped at the top of the board', (
    tester,
  ) async {
    // Màn dọc hẹp: nút gợi ý gọn, số lượt hiện bằng huy hiệu.
    await _pumpPlay(tester, const Size(360, 780));
    final top = tester.getTopLeft(find.byType(NonogramBoardShellSection)).dy;
    final badges = find.byType(CountBadge);
    expect(badges, findsNWidgets(2));
    for (final badge in badges.evaluate()) {
      expect(
        tester.getRect(find.byWidget(badge.widget)).top,
        greaterThanOrEqualTo(top),
      );
    }

    // Toàn màn hình: hàng nút nằm trong dock (dock cắt phần tràn).
    _bloc(tester).add(const FullscreenToggled());
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    final dock = tester.getRect(
      find.byKey(const ValueKey('nonogram-fullscreen-action-dock-body')),
    );
    for (final badge in find.byType(CountBadge).evaluate()) {
      expect(
        tester.getRect(find.byWidget(badge.widget)).top,
        greaterThanOrEqualTo(dock.top),
      );
    }
  });
}
