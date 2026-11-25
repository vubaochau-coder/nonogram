import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/ads/ad_scope.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/l10n/app_localizations.dart';

import '../nonogram_tutorial_controller.dart';

/// The overlay card of the steps that pause the tutorial: welcome, end of
/// the rules, end of the tools chapter and the final one.
class TutorialStepOverlay extends StatelessWidget {
  const TutorialStepOverlay({
    super.key,
    required this.task,
    required this.controller,
    required this.onClose,
  });

  final TutorialTask task;
  final NonogramTutorialController controller;

  /// Closes the tutorial; [showTechniques] opens the techniques guide next.
  final void Function({bool showTechniques}) onClose;

  static bool showsFor(TutorialTask task) => switch (task) {
    TutorialTask.intro ||
    TutorialTask.rulesDone ||
    TutorialTask.toolsDone ||
    TutorialTask.done => true,
    _ => false,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return switch (task) {
      TutorialTask.intro => _Overlay(
        alignment: Alignment.center,
        child: _OverlayCard(
          title: l10n.nonogramTutorialWelcomeTitle,
          body: l10n.nonogramTutorialWelcome,
          // Nói rõ ngay từ đầu: miễn phí, có quảng cáo (tuỳ chọn) và gói mua
          // một lần. Bản không có quảng cáo (web, iOS) thì không cần.
          extra: context.ads.isEnabled ? const _WelcomeInfo() : null,
          actions: [
            FilledButton(
              key: const ValueKey('nonogram-tutorial-start'),
              onPressed: controller.start,
              child: Text(l10n.nonogramTutorialStart),
            ),
          ],
        ),
      ),
      TutorialTask.rulesDone => _chapterDone(
        title: l10n.nonogramTutorialRulesDoneTitle,
        body: l10n.nonogramTutorialRulesDone,
        continueKey: 'nonogram-tutorial-continue',
        laterKey: 'nonogram-tutorial-later',
        l10n: l10n,
      ),
      TutorialTask.toolsDone => _chapterDone(
        title: l10n.nonogramTutorialToolsDoneTitle,
        body: l10n.nonogramTutorialToolsDone,
        continueKey: 'nonogram-tutorial-continue-techniques',
        laterKey: 'nonogram-tutorial-later-tools',
        l10n: l10n,
      ),
      _ => _Overlay(
        alignment: Alignment.bottomCenter,
        child: _OverlayCard(
          title: l10n.nonogramTutorialDoneTitle,
          body: l10n.nonogramTutorialDone,
          actions: [
            FilledButton(
              key: const ValueKey('nonogram-tutorial-techniques'),
              onPressed: () => onClose(showTechniques: true),
              child: Text(l10n.nonogramTutorialShowTechniques),
            ),
            TextButton(
              key: const ValueKey('nonogram-tutorial-play'),
              onPressed: onClose,
              child: Text(l10n.nonogramTutorialPlay),
            ),
          ],
        ),
      ),
    };
  }

  /// End of a chapter: continue with the next one, or leave for later.
  Widget _chapterDone({
    required String title,
    required String body,
    required String continueKey,
    required String laterKey,
    required AppLocalizations l10n,
  }) => _Overlay(
    alignment: Alignment.bottomCenter,
    child: _OverlayCard(
      title: title,
      body: body,
      actions: [
        FilledButton(
          key: ValueKey(continueKey),
          onPressed: controller.continueChapter,
          child: Text(l10n.nonogramTutorialContinue),
        ),
        TextButton(
          key: ValueKey(laterKey),
          onPressed: onClose,
          child: Text(l10n.nonogramTutorialLater),
        ),
      ],
    ),
  );
}

/// Lớp phủ mờ cho thẻ chào mừng / hoàn thành.
class _Overlay extends StatelessWidget {
  const _Overlay({required this.alignment, required this.child});

  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.4),
        child: Align(
          alignment: alignment,
          // Màn hình thấp (máy nhỏ, màn ngang): thẻ cuộn được, không tràn.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _OverlayCard extends StatelessWidget {
  const _OverlayCard({
    required this.title,
    required this.body,
    this.extra,
    required this.actions,
  });

  final String title;
  final String body;

  /// Nội dung thêm giữa lời dẫn và các nút.
  final Widget? extra;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.titleLarge.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                body,
                textAlign: TextAlign.center,
                style: context.bodyLarge.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              if (extra case final extra?) ...[
                const SizedBox(height: 16),
                extra,
              ],
              const SizedBox(height: 20),
              for (final action in actions) ...[
                action,
                const SizedBox(height: 4),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Khung thông tin trong thẻ chào mừng: chơi miễn phí, quảng cáo tuỳ chọn,
/// gói mua một lần.
class _WelcomeInfo extends StatelessWidget {
  const _WelcomeInfo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    final game = context.gameColors;

    Widget row(IconData icon, Color color, String text) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, size: 15, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              text,
              style: context.bodySmall.copyWith(
                color: colors.onSurface,
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );

    return Container(
      key: const ValueKey('nonogram-tutorial-welcome-info'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          row(Icons.check_rounded, game.success, l10n.nonogramTutorialInfoFree),
          const SizedBox(height: 10),
          row(
            Icons.play_arrow_rounded,
            const Color(0xFFF08C00),
            l10n.nonogramTutorialInfoAds,
          ),
          const SizedBox(height: 10),
          row(LucideIcons.crown, game.reward, l10n.nonogramTutorialInfoPremium),
        ],
      ),
    );
  }
}
