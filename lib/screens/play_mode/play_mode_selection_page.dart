import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_spacing.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/play_mode.dart';

/// Số màn đã giải / tổng số màn của một chế độ.
typedef PlayModeStats = ({int solved, int total});

typedef PlayModeStatsLoader = Future<PlayModeStats> Function(PlayMode mode);

/// Màn chọn chế độ chơi (chỉ có ở flavor `dev`), hiện trước màn chính.
class PlayModeSelectionPage extends StatefulWidget {
  const PlayModeSelectionPage({
    super.key,
    required this.onSelected,
    required this.loadStats,
    this.lastMode,
  });

  final ValueChanged<PlayMode> onSelected;
  final PlayModeStatsLoader loadStats;

  /// Chế độ chọn lần trước, được đánh dấu "Lần trước".
  final PlayMode? lastMode;

  @override
  State<PlayModeSelectionPage> createState() => _PlayModeSelectionPageState();
}

class _PlayModeSelectionPageState extends State<PlayModeSelectionPage> {
  late final Map<PlayMode, Future<PlayModeStats>> _stats = {
    for (final mode in PlayMode.values) mode: widget.loadStats(mode),
  };
  bool _selected = false;

  void _select(PlayMode mode) {
    // Chặn chạm hai lần trong lúc đang mở chế độ.
    if (_selected) return;
    setState(() => _selected = true);
    widget.onSelected(mode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(
                AppSpacing.pageHorizontalPadding + 8,
              ),
              children: [
                Text(
                  l10n.playModeTitle,
                  style: context.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.playModeSubtitle,
                  style: context.bodyMedium.copyWith(
                    color: context.color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                _ModeCard(
                  key: const ValueKey('play-mode-user'),
                  icon: LucideIcons.gamepad2,
                  title: l10n.playModeUserTitle,
                  body: l10n.playModeUserBody,
                  stats: _stats[PlayMode.user]!,
                  lastUsed: widget.lastMode == PlayMode.user,
                  enabled: !_selected,
                  onTap: () => _select(PlayMode.user),
                ),
                const SizedBox(height: 12),
                _ModeCard(
                  key: const ValueKey('play-mode-developer'),
                  icon: LucideIcons.wrench,
                  title: l10n.playModeDeveloperTitle,
                  body: l10n.playModeDeveloperBody,
                  stats: _stats[PlayMode.developer]!,
                  lastUsed: widget.lastMode == PlayMode.developer,
                  enabled: !_selected,
                  onTap: () => _select(PlayMode.developer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.stats,
    required this.lastUsed,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final Future<PlayModeStats> stats;
  final bool lastUsed;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    return Material(
      color: colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: lastUsed ? colors.primary : colors.outlineVariant,
          width: lastUsed ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          title,
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (lastUsed)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              context.l10n.playModeLastUsed,
                              style: context.labelSmall.copyWith(
                                color: colors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: context.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<PlayModeStats>(
                      future: stats,
                      builder: (context, snapshot) {
                        final s = snapshot.data;
                        return Text(
                          s == null
                              ? ' '
                              : context.l10n.playModeProgress(
                                s.solved,
                                s.total,
                              ),
                          style: context.labelLarge.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(LucideIcons.chevronRight, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
