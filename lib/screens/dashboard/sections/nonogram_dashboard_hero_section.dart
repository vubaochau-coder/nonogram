import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/widgets/nonogram_pixel_art.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/nonogram_dashboard_bloc.dart';
import '../bloc/nonogram_dashboard_state.dart';
import '../dashboard_navigation.dart';

/// Thẻ chính của dashboard: màn đang chơi dở hoặc màn kế tiếp, nút chơi.
class NonogramDashboardHeroSection extends StatelessWidget {
  const NonogramDashboardHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramDashboardBloc, NonogramDashboardState>(
      buildWhen:
          (p, c) =>
              p.isLoading != c.isLoading ||
              p.currentLevel != c.currentLevel ||
              p.currentPuzzle != c.currentPuzzle ||
              p.currentProgress != c.currentProgress ||
              p.hasInProgressSession != c.hasInProgressSession ||
              p.nextPlayableLevel != c.nextPlayableLevel ||
              p.totalLevels != c.totalLevels,
      builder: (context, state) {
        final Widget child;
        if (state.isLoading) {
          child = const _HeroSkeleton();
        } else if (state.isCampaignComplete) {
          child = _AllDoneContent(total: state.totalLevels);
        } else {
          child = _PlayContent(state: state);
        }
        return _HeroCard(child: child);
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final game = context.gameColors;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [game.heroStart, game.heroEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: game.heroStart.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(
            left: -36,
            bottom: -48,
            width: 150,
            height: 150,
            child: _DecorativeGrid(),
          ),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}

/// Lưới ô mờ trang trí góc thẻ.
class _DecorativeGrid extends StatelessWidget {
  const _DecorativeGrid();

  static const _pattern = ['01101', '11111', '11111', '01110', '00100'];

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.2,
      child: NonogramPixelArt(
        cells: [
          for (final row in _pattern)
            [for (final ch in row.split('')) ch == '1'],
        ],
        color: Colors.white.withValues(alpha: 0.09),
        emptyColor: Colors.white.withValues(alpha: 0.035),
      ),
    );
  }
}

class _PlayContent extends StatelessWidget {
  const _PlayContent({required this.state});

  final NonogramDashboardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final puzzle = state.currentPuzzle;
    final isResume = state.hasInProgressSession;
    final level = state.currentLevel;
    const onHero = Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Pill(
                    icon: isResume ? LucideIcons.pencil : LucideIcons.sparkles,
                    label:
                        isResume
                            ? l10n.nonogramDashboardInProgressBadge
                            : l10n.nonogramDashboardContinueNext,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.nonogramDashboardContinueLevel(level),
                    style: context.headlineMedium.copyWith(
                      color: onHero,
                      height: 1.1,
                    ),
                  ),
                  if (puzzle != null) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _MetaTag(
                          icon: LucideIcons.grid,
                          label: '${puzzle.cols} × ${puzzle.rows}',
                        ),
                        if (puzzle.difficulty.isNotEmpty)
                          _MetaTag(
                            icon: LucideIcons.gauge,
                            label: l10n.nonogramDashboardDifficulty(
                              puzzle.difficulty,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            _Preview(state: state),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: context.gameColors.heroStart,
            ),
            onPressed:
                () => openFromDashboard(
                  context,
                  NonogramPlayIntent(initialLevel: level),
                ),
            icon: Icon(isResume ? LucideIcons.play : LucideIcons.playCircle),
            label: Text(
              isResume
                  ? l10n.nonogramDashboardResumeAction
                  : l10n.nonogramDashboardPlay,
            ),
          ),
        ),
      ],
    );
  }
}

/// Ván dở: hình những ô đã tô. Màn mới: lưới trống với dấu "?".
class _Preview extends StatelessWidget {
  const _Preview({required this.state});

  final NonogramDashboardState state;

  @override
  Widget build(BuildContext context) {
    final snapshot = state.currentProgress;
    final puzzle = state.currentPuzzle;

    Widget content;
    if (snapshot != null && snapshot.gridData.isNotEmpty) {
      content = NonogramPixelArt(
        cells: [
          for (final row in snapshot.gridData)
            [for (final cell in row) cell == NonogramCellState.filled],
        ],
        color: Colors.white,
        emptyColor: Colors.white.withValues(alpha: 0.14),
      );
    } else {
      final rows = (puzzle?.rows ?? 5).clamp(1, 12);
      final cols = (puzzle?.cols ?? 5).clamp(1, 12);
      content = Stack(
        alignment: Alignment.center,
        children: [
          NonogramPixelArt(
            cells: List.generate(rows, (_) => List.filled(cols, false)),
            color: Colors.white,
            emptyColor: Colors.white.withValues(alpha: 0.14),
          ),
          const Icon(LucideIcons.helpCircle, color: Colors.white, size: 36),
        ],
      );
    }

    return Container(
      width: 96,
      height: 96,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: content,
    );
  }
}

class _AllDoneContent extends StatelessWidget {
  const _AllDoneContent({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.trophy,
            color: context.gameColors.reward,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.nonogramDashboardAllDoneTitle,
                style: context.titleLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                context.l10n.nonogramDashboardAllDoneDesc(total),
                style: context.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          // Bản dịch dài (vd. tiếng Đức) xuống dòng thay vì tràn khung.
          Flexible(
            child: Text(
              label,
              style: context.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withValues(alpha: 0.85);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(label, style: context.labelLarge.copyWith(color: color)),
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    final base = Colors.white.withValues(alpha: 0.18);
    Widget box(double w, double h, [double r = 8]) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(r),
      ),
    );

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: Colors.white.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    box(110, 24, 100),
                    const SizedBox(height: 14),
                    box(120, 30),
                    const SizedBox(height: 12),
                    box(150, 16),
                  ],
                ),
              ),
              box(96, 96, 20),
            ],
          ),
          const SizedBox(height: 20),
          box(double.infinity, 52, 16),
        ],
      ),
    );
  }
}
