import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_flavor.dart';
import 'package:nonogram/core/app_licenses.dart';
import 'package:nonogram/core/app_spacing.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/play_mode.dart';
import 'package:nonogram/data/nonogram_puzzle_source.dart';

/// Ghi công hình ảnh màn chơi và font, kèm lối vào trang giấy phép phần mềm
/// của Flutter (có cả các giấy phép đăng ký trong `registerAppLicenses`).
class AppLicensesPage extends StatefulWidget {
  const AppLicensesPage({super.key, this.flavor, this.levelSource});

  /// Mặc định là flavor của bản build hiện tại.
  final AppFlavor? flavor;

  /// Nguồn bộ màn có bản quyền, để đếm số màn của mỗi bộ hình.
  final AssetNonogramPuzzleSource? levelSource;

  @override
  State<AppLicensesPage> createState() => _AppLicensesPageState();
}

class _AppLicensesPageState extends State<AppLicensesPage> {
  late final Future<Map<String, int>> _counts = _countLevels();

  Future<Map<String, int>> _countLevels() async {
    final source =
        widget.levelSource ??
        AssetNonogramPuzzleSource(basePath: PlayMode.user.levelsPath);
    final counts = <String, int>{};
    try {
      for (final pack in (await source.index()).packs) {
        for (final puzzle in (await source.loadPack(pack.file)).values) {
          counts[puzzle.author] = (counts[puzzle.author] ?? 0) + 1;
        }
      }
    } catch (_) {
      // Không đếm được thì chỉ ẩn số màn.
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final flavor = widget.flavor ?? AppFlavor.current;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.licensesTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.scrollViewHorizontalPadding + 4,
            vertical: AppSpacing.scrollViewVerticalPadding,
          ),
          children: [
            _SectionTitle(l10n.licensesLevelArtHeading),
            Text(l10n.licensesLevelArtIntro, style: context.bodyMedium),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, int>>(
              future: _counts,
              builder: (context, snapshot) {
                final counts = snapshot.data ?? const {};
                return Column(
                  children: [
                    for (final source in levelArtSources)
                      _CreditCard(
                        key: ValueKey('licenses-${source.name}'),
                        title: source.name,
                        lines: [
                          l10n.licensesBy(source.author),
                          source.license,
                          if (counts[source.authorField] case final count?)
                            l10n.licensesLevelCount(count),
                        ],
                        url: source.url,
                      ),
                  ],
                );
              },
            ),
            if (flavor == AppFlavor.dev) ...[
              const SizedBox(height: 4),
              _Note(l10n.licensesDeveloperLevelsNote),
            ],
            const SizedBox(height: 20),
            _SectionTitle(l10n.licensesFontHeading),
            _CreditCard(
              title: 'Nunito',
              lines: [
                l10n.licensesBy('The Nunito Project Authors'),
                'SIL Open Font License 1.1',
              ],
              url: 'https://github.com/googlefonts/nunito',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                key: const ValueKey('licenses-software'),
                onPressed:
                    () => showLicensePage(
                      context: context,
                      applicationName: l10n.appTitle,
                    ),
                icon: const Icon(LucideIcons.fileText, size: 18),
                label: Text(l10n.licensesSoftwareButton),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: context.titleMedium.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CreditCard extends StatelessWidget {
  const _CreditCard({
    super.key,
    required this.title,
    required this.lines,
    required this.url,
  });

  final String title;
  final List<String> lines;
  final String url;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppSpacing.cardPadding + 2),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.titleSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            lines.join(' · '),
            style: context.bodySmall.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          SelectableText(
            url,
            style: context.bodySmall.copyWith(color: colors.primary),
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(LucideIcons.info, size: 16, color: colors.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: context.bodySmall.copyWith(color: colors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
