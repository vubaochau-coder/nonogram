import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Một ngôn ngữ giao diện, kèm tên hiển thị bằng chính ngôn ngữ đó (người
/// không đọc được ngôn ngữ hiện tại vẫn tìm ra ngôn ngữ của mình).
class AppLanguage {
  const AppLanguage(this.locale, this.nativeName);

  final Locale locale;
  final String nativeName;

  /// Mã lưu trên máy và dùng trong test, vd. `vi`, `zh_Hant`.
  String get tag => _tagOf(locale);
}

String _tagOf(Locale locale) => [
  locale.languageCode,
  if (locale.scriptCode != null) locale.scriptCode!,
  if (locale.countryCode != null) locale.countryCode!,
].join('_');

/// Các ngôn ngữ có trong app, theo thứ tự hiện trong danh sách chọn.
/// Thêm ngôn ngữ: thêm file `lib/l10n/app_<mã>.arb`, chạy `flutter gen-l10n`
/// rồi thêm vào đây (test kiểm tra hai danh sách khớp nhau).
const appLanguages = <AppLanguage>[
  AppLanguage(Locale('en'), 'English'),
  AppLanguage(Locale('vi'), 'Tiếng Việt'),
  AppLanguage(Locale('es'), 'Español'),
  AppLanguage(Locale('pt'), 'Português'),
  AppLanguage(Locale('fr'), 'Français'),
  AppLanguage(Locale('de'), 'Deutsch'),
  AppLanguage(Locale('it'), 'Italiano'),
  AppLanguage(Locale('ru'), 'Русский'),
  AppLanguage(Locale('tr'), 'Türkçe'),
  AppLanguage(Locale('id'), 'Bahasa Indonesia'),
  AppLanguage(Locale('th'), 'ไทย'),
  AppLanguage(Locale('ja'), '日本語'),
  AppLanguage(Locale('ko'), '한국어'),
  AppLanguage(Locale.fromSubtags(languageCode: 'zh'), '简体中文'),
  AppLanguage(
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    '繁體中文',
  ),
];

/// Chọn ngôn ngữ giao diện từ danh sách ngôn ngữ của máy.
///
/// Giống cách Flutter tự chọn, chỉ thêm một điều: máy báo `zh_TW`, `zh_HK`,
/// `zh_MO` (không có mã chữ viết, hay gặp ở Android cũ) thì dùng chữ Phồn thể
/// thay vì rơi về Giản thể. Không khớp ngôn ngữ nào thì dùng tiếng Anh.
Locale resolveAppLocale(List<Locale>? preferred, Iterable<Locale> supported) {
  for (final locale in preferred ?? const <Locale>[]) {
    final match = _match(locale, supported);
    if (match != null) return match;
  }
  return supported.firstWhere(
    (l) => l.languageCode == 'en',
    orElse: () => supported.first,
  );
}

const _traditionalChineseRegions = {'TW', 'HK', 'MO'};

Locale? _match(Locale locale, Iterable<Locale> supported) {
  final sameLanguage =
      supported.where((s) => s.languageCode == locale.languageCode).toList();
  if (sameLanguage.isEmpty) return null;

  var script = locale.scriptCode;
  if (script == null &&
      locale.languageCode == 'zh' &&
      _traditionalChineseRegions.contains(locale.countryCode)) {
    script = 'Hant';
  }
  if (script != null) {
    for (final s in sameLanguage) {
      if (s.scriptCode == script) return s;
    }
  }
  // Không có bản đúng chữ viết: dùng bản gốc của ngôn ngữ (không mã chữ viết).
  return sameLanguage.firstWhere(
    (s) => s.scriptCode == null && s.countryCode == null,
    orElse: () => sameLanguage.first,
  );
}

/// Ngôn ngữ người chơi chọn trong Cài đặt, lưu trên máy. `null` = theo ngôn
/// ngữ của máy (mặc định).
class AppLocaleController extends ValueNotifier<Locale?> {
  AppLocaleController._(this._box, Locale? initial) : super(initial);

  /// Dùng chung box tuỳ chọn với `AppThemeModeController`.
  static const _boxName = 'nonogram_preferences_v1';
  static const _localeKey = 'locale';

  final Box<dynamic>? _box;

  /// Gọi sau `Hive.initFlutter()`. Mã đã lưu mà app không còn hỗ trợ thì về
  /// theo ngôn ngữ của máy.
  static Future<AppLocaleController> load() async {
    try {
      final box = await Hive.openBox<dynamic>(_boxName);
      return AppLocaleController._(box, _parse(box.get(_localeKey)));
    } catch (_) {
      return AppLocaleController._(null, null);
    }
  }

  /// Dùng trong test: không lưu.
  AppLocaleController.inMemory([super.initial]) : _box = null;

  static Locale? _parse(Object? raw) {
    if (raw is! String) return null;
    for (final language in appLanguages) {
      if (language.tag == raw) return language.locale;
    }
    return null;
  }

  /// `null` = theo ngôn ngữ của máy.
  Future<void> setLocale(Locale? locale) async {
    final next =
        locale == null
            ? null
            : appLanguages.firstWhere((l) => l.tag == _tagOf(locale)).locale;
    if (value == next) return;
    value = next;
    if (next == null) {
      await _box?.delete(_localeKey);
    } else {
      await _box?.put(_localeKey, _tagOf(next));
    }
  }
}

/// Tên ngôn ngữ đang dùng (hiện trên nút chọn ngôn ngữ).
String appLanguageName(Locale locale) {
  final tag = _tagOf(locale);
  for (final language in appLanguages) {
    if (language.tag == tag) return language.nativeName;
  }
  return appLanguages
      .firstWhere(
        (l) => l.locale.languageCode == locale.languageCode,
        orElse: () => appLanguages.first,
      )
      .nativeName;
}
