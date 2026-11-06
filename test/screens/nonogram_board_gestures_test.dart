import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/data/nonogram_puzzle_source.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/nonogram_play_page.dart';
import 'package:nonogram/screens/play/nonogram_transformation_controller_provider.dart';
import 'package:nonogram/screens/play/sections/nonogram_board_viewport.dart';

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

Future<void> _pumpPlay(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    RepositoryProvider<NonogramRepository>.value(
      value: NonogramRepository(_BigPuzzleSource(), FakeNonogramLocalService()),
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

  testWidgets('holding the pan button turns a one-finger drag into a pan', (
    tester,
  ) async {
    await _pumpPlay(tester, phone);
    final before = _gridOffset(tester);
    final origin = _boardOrigin(tester);
    final cell = _bloc(tester).state.cellSize;

    final hold = await tester.startGesture(
      tester.getCenter(find.byKey(const ValueKey('nonogram-hold-to-pan'))),
    );
    await tester.pump();

    final drag = await tester.startGesture(
      origin + before + Offset(cell * 3.5, cell * 3.5),
      pointer: 7,
    );
    for (var i = 0; i < 10; i++) {
      await drag.moveBy(const Offset(-20, -20));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await drag.up();
    await hold.up();
    await tester.pump(const Duration(milliseconds: 50));

    final after = _gridOffset(tester);
    expect(after.dx, lessThan(before.dx - 100));
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

  testWidgets('touching a cell shows the full clues of its row and column', (
    tester,
  ) async {
    await _pumpPlay(tester, phone);
    final t = _gridOffset(tester);
    final origin = _boardOrigin(tester);
    final cell = _bloc(tester).state.cellSize;

    final gesture = await tester.startGesture(
      origin + t + Offset(cell * 4.5, cell * 2.5),
    );
    await tester.pump();
    expect(find.text('Row 3'), findsOneWidget);
    expect(find.text('Col 5'), findsOneWidget);
    await gesture.up();
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Row 3'), findsNothing);
  });

  testWidgets('landscape drops the app bar and uses a side rail', (
    tester,
  ) async {
    await _pumpPlay(tester, const Size(900, 400));
    expect(find.byType(AppBar), findsNothing);
    expect(find.byIcon(LucideIcons.arrowLeft), findsOneWidget);
    expect(find.byIcon(LucideIcons.settings), findsOneWidget);

    // Không còn chừa 64px phía trên: dải gợi ý trên bắt đầu sát mép.
    final t = _gridOffset(tester);
    expect(t.dy, lessThan(400 * 0.30 + 1));
  });
}
