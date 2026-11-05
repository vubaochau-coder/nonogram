import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/nonogram_play_bloc.dart';
import 'bloc/nonogram_play_event.dart';
import 'bloc/nonogram_play_state.dart';
import 'nonogram_transformation_controller_provider.dart';
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

        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.isSolved && state.puzzle != null) {
          return _NonogramCompletionView(state: state);
        }

        return Scaffold(
          appBar: state.isFullscreen ? null : const NonogramPlayAppBarSection(),
          body: const NonogramBoardShellSection(),
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
