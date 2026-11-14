import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/ads/ad_scope.dart';
import 'package:nonogram/core/app_locale.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/play_mode.dart';
import 'package:nonogram/premium/premium_card.dart';
import 'package:nonogram/premium/premium_controller.dart';
import 'package:nonogram/screens/licenses/app_licenses_page.dart';
import 'package:nonogram/tester/tester_settings.dart';
import 'package:nonogram/tester/tester_tools_page.dart';
import 'package:nonogram/widgets/app_language_selector.dart';
import 'package:provider/provider.dart';

/// Tab "Tôi": gói không quảng cáo, cài đặt (giao diện, ngôn ngữ, âm thanh),
/// trợ giúp (cách chơi, kỹ thuật giải) và các mục khác (quyền riêng tư quảng
/// cáo, giấy phép, đổi chế độ chơi ở bản dev).
class MePage extends StatelessWidget {
  const MePage({super.key});

  static T? _maybe<T>(BuildContext context, {bool listen = false}) {
    try {
      return Provider.of<T>(context, listen: listen);
    } on ProviderNotFoundException {
      return null;
    }
  }

  Future<void> _openTutorial(BuildContext context) async {
    final showTechniques = await context.navigate(
      const NonogramTutorialIntent(),
    );
    if (!context.mounted || showTechniques != true) return;
    await context.navigate(const NonogramGuideIntent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final premium = _maybe<PremiumController>(context, listen: true);
    final showPremium =
        premium != null && (premium.isPremium || premium.canPurchase);
    final themeMode = _maybe<AppThemeModeController>(context);
    final locale = _maybe<AppLocaleController>(context);
    final sounds = _maybe<AppSoundController>(context);
    final switcher = _maybe<PlayModeSwitcher>(context);
    final tester = _maybe<TesterSettings>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            if (showPremium) ...[
              const PremiumCard(),
              const SizedBox(height: 20),
            ],
            _Group(
              title: l10n.nonogramSettingsTitle,
              children: [
                if (themeMode != null)
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeMode,
                    builder: (context, mode, _) {
                      final dark = mode == ThemeMode.dark;
                      return _Tile(
                        key: const ValueKey('me-theme'),
                        icon: dark ? LucideIcons.moon : LucideIcons.sun,
                        color: const Color(0xFFF59E0B),
                        label: l10n.appThemeTitle,
                        value: dark ? l10n.appThemeDark : l10n.appThemeLight,
                        // Bấm là đổi Sáng ⇄ Tối ngay.
                        trailing: const SizedBox.shrink(),
                        onTap: themeMode.toggle,
                      );
                    },
                  ),
                if (locale != null)
                  _Tile(
                    key: const ValueKey('me-language'),
                    icon: LucideIcons.globe,
                    color: const Color(0xFF3B82F6),
                    label: l10n.settingsLanguage,
                    value: appLanguageName(Localizations.localeOf(context)),
                    onTap: () => showAppLanguageDialog(context, locale),
                  ),
                if (sounds != null)
                  ValueListenableBuilder<bool>(
                    valueListenable: sounds,
                    builder: (context, enabled, _) {
                      return _Tile(
                        icon:
                            enabled ? LucideIcons.volume2 : LucideIcons.volumeX,
                        color: const Color(0xFF7C5CDB),
                        label: l10n.settingsSound,
                        onTap: () => sounds.setEnabled(!enabled),
                        trailing: Switch(
                          key: const ValueKey('me-sound'),
                          value: enabled,
                          onChanged: sounds.setEnabled,
                        ),
                      );
                    },
                  ),
              ],
            ),
            _Group(
              title: l10n.meHelp,
              children: [
                _Tile(
                  key: const ValueKey('me-tutorial'),
                  icon: LucideIcons.graduationCap,
                  color: const Color(0xFF22A06B),
                  label: l10n.nonogramTutorialTitle,
                  onTap: () => _openTutorial(context),
                ),
                _Tile(
                  key: const ValueKey('me-guide'),
                  icon: LucideIcons.bookOpen,
                  color: const Color(0xFF14A3B8),
                  label: l10n.nonogramGuideTitle,
                  onTap: () => context.navigate(const NonogramGuideIntent()),
                ),
              ],
            ),
            // Chỉ bản `dev`: chuỗi không dịch (dành cho người test nội bộ).
            if (tester != null)
              _Group(
                title: 'Tester',
                children: [
                  _Tile(
                    key: const ValueKey('me-tester-tools'),
                    icon: LucideIcons.flaskConical,
                    color: const Color(0xFFF97316),
                    label: 'Công cụ tester',
                    onTap:
                        () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const TesterToolsPage(),
                          ),
                        ),
                  ),
                ],
              ),
            ValueListenableBuilder<bool>(
              valueListenable: context.ads.privacyOptionsRequired,
              builder: (context, privacyRequired, _) {
                return _Group(
                  title: l10n.meMore,
                  children: [
                    // Người dùng ở vùng áp dụng GDPR phải đổi lại được lựa
                    // chọn đồng ý.
                    if (privacyRequired)
                      _Tile(
                        key: const ValueKey('me-ad-privacy'),
                        icon: LucideIcons.shieldCheck,
                        color: const Color(0xFFE5486B),
                        label: l10n.settingsAdPrivacy,
                        onTap: () => context.ads.showPrivacyOptions(),
                      ),
                    _Tile(
                      key: const ValueKey('me-licenses'),
                      icon: LucideIcons.scale,
                      color: const Color(0xFF8A93A6),
                      label: l10n.settingsLicenses,
                      onTap:
                          () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const AppLicensesPage(),
                            ),
                          ),
                    ),
                    if (switcher != null)
                      _Tile(
                        key: const ValueKey('me-switch-play-mode'),
                        icon: LucideIcons.repeat,
                        color: const Color(0xFF6741D9),
                        label: l10n.settingsSwitchPlayMode,
                        onTap: switcher.switchMode,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    final divider = Padding(
      padding: const EdgeInsets.only(left: 64),
      child: Divider(height: 1, color: context.gameColors.cardBorder),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 8),
            child: Text(
              title,
              style: context.labelLarge.copyWith(
                color: context.color.onSurfaceVariant,
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) divider,
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Một dòng: icon trên nền màu bo góc, tên, giá trị hiện tại (nếu có), mũi
/// tên hoặc [trailing].
class _Tile extends StatelessWidget {
  const _Tile({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 19),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: context.titleSmall)),
              if (value != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    value!,
                    style: context.bodyMedium.copyWith(
                      color: context.color.onSurfaceVariant,
                    ),
                  ),
                ),
              trailing ??
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      LucideIcons.chevronRight,
                      size: 20,
                      color: context.color.outline,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
