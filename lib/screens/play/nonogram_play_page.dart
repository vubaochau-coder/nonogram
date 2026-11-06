import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/nonogram_play_bloc.dart';
import 'bloc/nonogram_play_event.dart';
import 'bloc/nonogram_play_state.dart';
import 'engine/nonogram_board_layout.dart';
import 'nonogram_board_ui_controller.dart';
import 'nonogram_transformation_controller_provider.dart';
import 'widgets/board_viewport_reporter.dart';
import 'sections/nonogram_board_shell_section.dart';
import 'sections/nonogram_play_app_bar_section.dart';
import 'sections/nonogram_completion_result_section.dart';
import 'package:nested/nested.dart';

class NonogramPlayPage extends StatefulWidget {
  final int initialLevel;

  const NonogramPlayPage({super.key, this.initialLevel = 1});

  @override
  State<NonogramPlayPage> createState() => _NonogramPlayPageState();
}

class _NonogramPlayPageState extends State<NonogramPlayPage> {
  late final TransformationController _transformationController;
  final _boardUiController = NonogramBoardUiController();

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _boardUiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Nested(
      children: [
        NonogramTransformationControllerProvider(
          controller: _transformationController,
        ),
        NonogramBoardUiScope(controller: _boardUiController),
        BlocProvider<NonogramPlayBloc>(
          create: (context) {
            return NonogramPlayBloc(
              repository: context.read(),
              initialLevel: widget.initialLevel,
            )..add(const InitialRequested());
          },
        ),
        BlocListener<NonogramPlayBloc, NonogramPlayState>(
          listenWhen: (p, c) => p.isFullscreen != c.isFullscreen,
          listener: (context, state) {
            if (state.isFullscreen) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
            } else {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            }
          },
        ),
      ],
      child: const _NonogramPlayView(),
    );
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

        // Màn ngang: bỏ app bar để lưới có thêm chiều cao; nút quay lại và
        // cài đặt chuyển vào cột nút công cụ bên phải.
        final landscape = NonogramBoardLayout.isLandscapeViewport(
          MediaQuery.sizeOf(context),
        );
        final showAppBar = !state.isFullscreen && !landscape;

        Widget body(Widget child) {
          final reporter = BoardViewportReporter(child: child);
          return landscape ? SafeArea(child: reporter) : reporter;
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
          onNextLevel: () {
            context.read<NonogramPlayBloc>().add(const NextLevelRequested());
          },
        ),
      ),
    );
  }
}
