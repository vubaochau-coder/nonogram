import 'package:nonogram/ads/ad_scope.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/rating/app_rating_dialog.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/nonogram_play_bloc.dart';
import 'bloc/nonogram_play_event.dart';
import 'bloc/nonogram_play_state.dart';
import 'engine/nonogram_board_layout.dart';
import 'nonogram_transformation_controller_provider.dart';
import 'widgets/board_viewport_reporter.dart';
import 'sections/nonogram_board_shell_section.dart';
import 'sections/nonogram_play_app_bar_section.dart';
import 'sections/nonogram_completion_result_section.dart';
import 'sections/nonogram_landscape_info_panel.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'coach/nonogram_play_coach.dart';

class NonogramPlayPage extends StatefulWidget {
  final int initialLevel;

  const NonogramPlayPage({super.key, this.initialLevel = 1});

  @override
  State<NonogramPlayPage> createState() => _NonogramPlayPageState();
}

class _NonogramPlayPageState extends State<NonogramPlayPage> {
  late final TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Nested(
      children: [
        NonogramTransformationControllerProvider(
          controller: _transformationController,
        ),
        ChangeNotifierProvider(create: (_) => NonogramCoachReplayNotifier()),
        BlocProvider<NonogramPlayBloc>(
          create: (context) {
            return NonogramPlayBloc(
              repository: context.read(),
              initialLevel: widget.initialLevel,
            )..add(const InitialRequested());
          },
        ),
      ],
      child: const _SystemUiModeSync(child: _NonogramPlayView()),
    );
  }
}

/// Ẩn thanh trạng thái / điều hướng khi bật toàn màn hình hoặc khi màn
/// ngang (chiều cao quý hơn); hiện lại và bỏ khoá hướng màn hình (nút xoay)
/// khi rời trang chơi.
class _SystemUiModeSync extends StatefulWidget {
  const _SystemUiModeSync({required this.child});

  final Widget child;

  @override
  State<_SystemUiModeSync> createState() => _SystemUiModeSyncState();
}

class _SystemUiModeSyncState extends State<_SystemUiModeSync> {
  bool? _immersive;

  void _apply(bool immersive) {
    if (immersive == _immersive) return;
    _immersive = immersive;
    SystemChrome.setEnabledSystemUIMode(
      immersive ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  @override
  void dispose() {
    if (_immersive == true) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    // Bỏ khoá hướng màn hình do nút xoay đặt ra.
    SystemChrome.setPreferredOrientations(const []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final landscape = NonogramBoardLayout.isLandscapeViewport(
      MediaQuery.sizeOf(context),
    );
    final fullscreen = context.select<NonogramPlayBloc, bool>(
      (bloc) => bloc.state.isFullscreen,
    );
    _apply(landscape || fullscreen);
    return widget.child;
  }
}

class _NonogramPlayView extends StatelessWidget {
  const _NonogramPlayView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) {
        return p.isSolved != c.isSolved ||
            p.isLoading != c.isLoading ||
            p.isFullscreen != c.isFullscreen ||
            c is NonogramPlayErrorState;
      },
      builder: (context, state) {
        if (state is NonogramPlayErrorState) {
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.nonogramPlayPageTitle)),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: context.color.error,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: context.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<NonogramPlayBloc>().add(
                        const LevelLoadRequested(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(context.l10n.commonRetry),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.isSolved && state.puzzle != null) {
          return _NonogramCompletionView(state: state);
        }

        // Màn ngang: bỏ app bar (và tự ẩn thanh hệ thống) để lưới có thêm
        // chiều cao; quay lại, thông tin màn, xoay, cài đặt chuyển sang cột
        // trái, gợi ý và Tô / X ở góc dưới bên phải.
        final screen = MediaQuery.sizeOf(context);
        final landscape = NonogramBoardLayout.isLandscapeViewport(screen);
        final showAppBar = !state.isFullscreen && !landscape;
        // Màn gần vuông thì không chừa chỗ cho bảng thông tin, để phần còn
        // lại vẫn là khung ngang.
        const sides =
            NonogramLandscapeLeftRail.panelWidth +
            NonogramBoardLayout.railReserve;
        final roomForInfo = screen.width - sides > screen.height;

        Widget body(Widget child) {
          final reporter = BoardViewportReporter(child: child);
          // Màn dọc vẫn chừa mép dưới, để lưới không nằm dưới thanh vuốt
          // của hệ thống (vuốt ở đó sẽ thoát app thay vì tô).
          if (!landscape) return SafeArea(top: false, child: reporter);
          // Cột trái (quay lại, thông tin, xoay, cài đặt) nằm ngoài vùng đo,
          // nên mở / thu gọn bảng thông tin thì bàn chơi tự tính lại cỡ ô.
          return SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NonogramLandscapeLeftRail(allowPanel: roomForInfo),
                Expanded(child: reporter),
              ],
            ),
          );
        }

        if (state.isLoading) {
          // Có app bar giả để khung đo được khớp với lúc bàn chơi hiện ra.
          return Scaffold(
            appBar: showAppBar ? AppBar() : null,
            body: body(const Center(child: CircularProgressIndicator())),
          );
        }

        return Scaffold(
          appBar: showAppBar ? const NonogramPlayAppBarSection() : null,
          body: body(const NonogramBoardShellSection()),
        );
      },
    );
  }
}

class _NonogramCompletionView extends StatelessWidget {
  final NonogramPlayState state;

  const _NonogramCompletionView({required this.state});

  @override
  Widget build(BuildContext context) {
    final puzzle = state.puzzle!;
    final duration = DateTime.now().difference(state.startTime);

    return Scaffold(
      appBar: state.isFullscreen ? null : const NonogramPlayAppBarSection(),
      body: SafeArea(
        child: NonogramCompletionResultSection(
          puzzle: puzzle,
          completionDuration: duration,
          onNextLevel: () async {
            final bloc = context.read<NonogramPlayBloc>();
            await _onLeaveCompletion(context);
            if (!bloc.isClosed) bloc.add(const NextLevelRequested());
          },
          onDashboard: () async {
            final navigator = Navigator.of(context);
            await _onLeaveCompletion(context);
            navigator.maybePop();
          },
        ),
      ),
    );
  }
}

/// Rời màn hoàn thành là lúc nghỉ tự nhiên: hỏi đánh giá app nếu đến lúc,
/// không thì có thể hiện quảng cáo xen kẽ (đã giới hạn tần suất). Không hiện
/// cả hai cùng lúc.
Future<void> _onLeaveCompletion(BuildContext context) async {
  final ads = context.ads;
  final solved =
      (await context.read<NonogramRepository>().getCompletedProgress()).length;
  if (!context.mounted) return;
  if (await maybeAskForRating(context, solved)) return;
  await ads.onLevelCompleteExit();
}
