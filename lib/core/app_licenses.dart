import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Một bộ hình dùng làm màn chơi, hiện trong màn Giấy phép.
class LevelArtSource {
  const LevelArtSource({
    required this.name,
    required this.author,
    required this.license,
    required this.url,
    required this.licenseUrl,
    required this.licenseAsset,
    required this.authorField,
  });

  final String name;
  final String author;
  final String license;
  final String url;
  final String licenseUrl;

  /// Văn bản giấy phép đầy đủ, đăng ký vào `LicenseRegistry`.
  final String licenseAsset;

  /// Giá trị trường `author` của các màn lấy từ bộ này (để đếm số màn).
  final String authorField;
}

/// Nguồn của bộ màn có bản quyền (`assets/levels/`): các bộ icon được chuyển
/// thành màn, và các màn nonogram có giấy phép mở dùng nguyên bản. Xem
/// `docs/credits.md`.
const levelArtSources = <LevelArtSource>[
  LevelArtSource(
    name: 'Streamline Pixel',
    author: 'Streamline',
    license: 'CC BY 4.0',
    url: 'https://github.com/webalys-hq/streamline-vectors',
    licenseUrl: 'https://creativecommons.org/licenses/by/4.0/',
    licenseAsset: 'assets/licenses/streamline-pixel-NOTICE.txt',
    authorField: 'Streamline Pixel (Streamline)',
  ),
  LevelArtSource(
    name: 'Pixelarticons',
    author: 'Gerrit Halfmann',
    license: 'MIT',
    url: 'https://github.com/halfmage/pixelarticons',
    licenseUrl: 'https://github.com/halfmage/pixelarticons/blob/master/LICENSE',
    licenseAsset: 'assets/licenses/pixelarticons-LICENSE.txt',
    authorField: 'Pixelarticons (Gerrit Halfmann)',
  ),
  LevelArtSource(
    name: 'webpbn.com',
    author: 'Jan Wolter',
    license: 'CC BY 3.0',
    url: 'https://webpbn.com',
    licenseUrl: 'https://creativecommons.org/licenses/by/3.0/',
    licenseAsset: 'assets/licenses/webpbn-NOTICE.txt',
    authorField: 'Jan Wolter (webpbn.com)',
  ),
  LevelArtSource(
    name: 'gnonograms',
    author: 'Frederico Vera',
    license: 'CC BY-SA 4.0',
    url: 'https://github.com/Sprunth/nonogram-db',
    licenseUrl: 'https://creativecommons.org/licenses/by-sa/4.0/',
    licenseAsset: 'assets/licenses/gnonograms-NOTICE.txt',
    authorField: 'Frederico Vera (gnonograms)',
  ),
  LevelArtSource(
    name: 'nonogram-db',
    author: 'Michael Terry',
    license: 'CC BY-SA 4.0',
    url: 'https://github.com/Sprunth/nonogram-db',
    licenseUrl: 'https://creativecommons.org/licenses/by-sa/4.0/',
    licenseAsset: 'assets/licenses/nonogram-db-NOTICE.txt',
    authorField: 'Michael Terry (nonogram-db)',
  ),
];

const nunitoLicenseAsset = 'assets/fonts/Nunito-OFL.txt';

/// Thêm giấy phép của hình màn chơi và font vào `LicenseRegistry`, để chúng
/// hiện cùng giấy phép các thư viện trong trang giấy phép phần mềm.
void registerAppLicenses({AssetBundle? bundle}) {
  final assets = bundle ?? rootBundle;
  LicenseRegistry.addLicense(() async* {
    for (final source in levelArtSources) {
      yield LicenseEntryWithLineBreaks([
        source.name,
      ], await assets.loadString(source.licenseAsset));
    }
    yield LicenseEntryWithLineBreaks([
      'Nunito',
    ], await assets.loadString(nunitoLicenseAsset));
  });
}
