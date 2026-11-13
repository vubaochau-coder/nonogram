# Nonopix

<img src="assets/branding/logo.png" width="96" alt="Logo Nonopix">


**Nonopix** là game nonogram (tô ô theo gợi ý số để lộ ra hình) viết bằng
Flutter, tách ra từ project Nexora. **Chơi được khi không có mạng**: màn chơi đóng gói sẵn trong app,
tiến độ lưu trên máy, không cần tài khoản. Mạng chỉ dùng để tải quảng cáo
(bản store trên Android, xem [Quảng cáo](#quảng-cáo-admob)).

## Chạy game

```bash
flutter pub get
flutter run --flavor dev      # Android: luôn phải chọn flavor
```

### Flavor

| Flavor | Dùng cho | Màn chọn chế độ chơi | Bộ màn |
|---|---|---|---|
| `dev` | Bản thử nội bộ, mặc định trên GitHub Actions (workflow Distribute) | Có | Chế độ người dùng (`assets/levels/`) + chế độ nhà phát triển (`assets/levels_dev/`) |
| `store` | Bản phát hành lên store (workflow "Store build", chạy tay) | Không | Chỉ `assets/levels/` |

- Mỗi chế độ chơi lưu tiến độ riêng. Chế độ nhà phát triển dùng lại box tiến
  độ cũ (`nonogram_offline_v1`), nên tiến độ của các bản thử trước đây vẫn còn.
- `assets/levels_dev/` (574 màn lấy từ nonogram.org, không được dùng thương
  mại) chỉ được đóng gói khi build `--flavor dev`.
- Build bản store: `flutter build appbundle --release --flavor store`.
- iOS và web chưa cấu hình flavor: build không có `--flavor` chạy như bản
  `store` (không có chế độ nhà phát triển).
- Nhánh `beta` giữ nguyên trạng thái `main` trước khi đổi bộ màn (vẫn dùng bộ
  màn crawl).

Hỗ trợ Android, iOS và Web.

## Ngôn ngữ

Giao diện có 15 ngôn ngữ: Anh, Việt, Tây Ban Nha, Bồ Đào Nha, Pháp, Đức, Ý,
Nga, Thổ Nhĩ Kỳ, Indonesia, Thái, Nhật, Hàn, Trung giản thể và Trung phồn thể.

- Mặc định theo ngôn ngữ của máy; máy dùng ngôn ngữ không có trong danh sách
  thì hiện tiếng Anh. Máy báo `zh_TW` / `zh_HK` / `zh_MO` (Android cũ, không
  có mã chữ viết) dùng tiếng Trung phồn thể (`resolveAppLocale` trong
  `lib/core/app_locale.dart`).
- Người chơi đổi được ngôn ngữ bằng nút quả địa cầu trên trang chính hoặc trong
  Cài đặt khi đang chơi; lựa chọn được lưu trên máy (chọn "Theo ngôn ngữ của
  máy" để bỏ).
- Tên màn chơi (lấy từ tên icon gốc) giữ nguyên tiếng Anh ở mọi ngôn ngữ.
- **Thêm ngôn ngữ:** tạo `lib/l10n/app_<mã>.arb` (đủ mọi khoá của
  `app_en.arb`), chạy `flutter gen-l10n`, thêm vào `appLanguages` trong
  `lib/core/app_locale.dart` và `CFBundleLocalizations` trong
  `ios/Runner/Info.plist`.
- `test/core/app_locale_test.dart` kiểm tra mọi file `.arb` đủ khoá, đúng
  placeholder và khớp danh sách chọn ngôn ngữ;
  `test/l10n/locale_layout_test.dart` dựng các màn chính bằng từng ngôn ngữ
  trên điện thoại 360×640 (font Nunito thật) để bắt chữ dịch bị tràn.

Bản web cần build kèm CanvasKit để chạy được khi không có mạng:

```bash
flutter build web --no-web-resources-cdn
```

## Điều khiển

Nút gạt **Tô / X** trên thanh công cụ chọn việc một lần chạm sẽ làm:

| Thao tác | Chế độ Tô (■) | Chế độ X (✕) |
|---|---|---|
| Chạm | Tô / xoá ô tô | Đánh / bỏ X |
| Nhấn giữ | Đánh X vào ô trống | Tô ô |
| Kéo một ngón bắt đầu trên lưới | Tô liên tiếp | Đánh X liên tiếp (không đè ô đã tô) |
| Kéo một ngón trên dải gợi ý trái | Cuộn dọc; vuốt ngang để xem các số bị cắt | như bên trái |
| Kéo một ngón trên dải gợi ý trên | Cuộn ngang; vuốt dọc để xem các số bị cắt | như bên trái |
| Kéo một ngón trên chỗ trống | Kéo bàn | Kéo bàn |
| Hai ngón | Kéo bàn | như bên trái |
| Chuột / trackpad | Lăn để kéo | như bên trái |

- Đang tô mà ngón tay tới sát mép lưới thì bàn tự trôi theo.
- Hai dải gợi ý luôn dính mép trái / mép trên khi kéo lưới đi. Mỗi dải
  chiếm tối đa 30% chiều tương ứng; nhiều số hơn thì chỉ hiện các số gần
  lưới nhất. Hàng / cột nào còn số khuất thì ở mép phía đó (xa lưới, hoặc
  sát lưới khi đã cuộn dải ra) có chip cam `+n` to bằng một ô số; n đếm cả
  số nằm dưới chip (`ClueOverflow`).
- Không có zoom: cỡ ô luôn là cỡ lớn nhất vừa màn hình trong khoảng
  28–44px (tính lại khi xoay màn hình); lưới lớn hơn thì kéo để xem.
- Nút xoay màn hình (điện thoại / máy tính bảng) chuyển dọc ⇄ ngang và khoá
  ở hướng đó; rời trang chơi thì bỏ khoá.
- Màn hình ngang tự ẩn thanh hệ thống, không có app bar. Cột trái: quay
  lại và ⓘ ở góc trên, xoay màn hình và cài đặt ở góc dưới. Bấm ⓘ thì bảng
  thông tin màn (tên, số màn, kích thước, độ khó) trượt ra từ trái, phủ lên
  hai nút góc trên; cột nới rộng theo bảng nên bảng không che bàn chơi.
  Trạng thái mở / thu gọn được nhớ trên máy. Mép phải chỉ còn gợi ý, gậy
  phép và Tô / X (theo thứ tự đó), ở góc trên bên phải.
- "Chơi lại từ đầu" nằm trong Cài đặt và luôn hỏi xác nhận.
- Ô trống trên hàng/cột đã khớp gợi ý hiện chấm tròn; X màu chàm là dấu
  người chơi tự đánh.

## Hướng dẫn chơi

- Lần đầu mở app (chưa giải màn nào), bài **Cách chơi** tự mở: một câu đố
  5×5 hiện dần từng hàng, mỗi bước có lời dẫn, viền vàng chỗ cần làm và bàn
  tay chỉ chỗ cần chạm. Chỉ nhận đúng thao tác của bước đó; làm sai thì lời
  dẫn rung nhẹ. Có nút **Bỏ qua**.
- Học xong có nút **Xem các kỹ thuật giải** dẫn sang trang Hướng dẫn (lý
  thuyết). Trên trang Hướng dẫn có thẻ **Học qua bài tập** để mở lại.
- Kịch bản (bài 5×5, các bước) nằm trong
  `lib/screens/tutorial/nonogram_tutorial_controller.dart`.

## Cấu trúc

```
lib/
  main.dart                  Khởi tạo Hive, repository, quảng cáo, MaterialApp
  ads/                       Quảng cáo AdMob (có thưởng + xen kẽ), tần suất, ID
  core/                      Theme (AppTheme + GameColors), điều hướng (AppRouteIntent), tiện ích
  data/
    nonogram_puzzle_source.dart   Đọc màn chơi từ assets/levels/
    hive_nonogram_local_service.dart  Lưu ván dở + màn đã hoàn thành
    nonogram_repository.dart      Gom dữ liệu màn chơi + tiến độ, logic campaign
  models/                    Puzzle, snapshot ván dở, kết quả hoàn thành
  screens/
    dashboard/               Màn chính: chơi tiếp / thử thách tiếp theo, thống kê
    play/                    Gameplay (bloc, engine, solver, bố cục bàn chơi, UI)
    history/                 Danh sách + chi tiết màn đã hoàn thành
    guide/                   Hướng dẫn cách giải (lý thuyết, có lối vào bài tập)
    tutorial/                Bài hướng dẫn tương tác 5×5 ("Cách chơi")
    painters/                CustomPainter cho lưới, gợi ý, đáp án
  l10n/                      Chuỗi dịch (app_<mã>.arb, 15 ngôn ngữ) + code sinh từ đó
assets/
  levels/                    1.061 màn chơi có bản quyền (sinh bằng tools/build_levels.dart)
  levels_dev/                574 màn crawl, chỉ có ở flavor dev (chế độ nhà phát triển)
  licenses/                  Văn bản giấy phép hình màn chơi (hiện ở Cài đặt → Giấy phép)
  fonts/                     Font Nunito (giấy phép OFL, xem Nunito-OFL.txt)
tools/
  build_levels.dart          levels.json -> assets/levels/, kiểm tra nghiệm duy nhất
  image_levels/              Sinh + duyệt màn từ bộ icon mở giấy phép (nguồn của assets/levels/)
  generate_icons.py          Vẽ launcher icon / splash / favicon
docs/
  level_format.md            Định dạng dữ liệu màn chơi
  credits.md                 Ghi công + giấy phép hình dùng làm màn chơi
  gameplay_rules.md          Quy tắc campaign, snapshot, hint
```

- Sửa chuỗi dịch trong `lib/l10n/*.arb` rồi chạy `flutter gen-l10n`.
- Thêm/cập nhật màn chơi: xem [docs/level_format.md](docs/level_format.md).

## Kiểm tra

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

`test/data/level_assets_test.dart` kiểm tra toàn bộ dữ liệu trong
`assets/levels/` (đủ level, đúng định dạng, mỗi màn có đúng một nghiệm).

## Quảng cáo (AdMob)

Có quảng cáo trên **Android** (cả `store` và `dev`; bản `dev` luôn dùng ID
thử nghiệm). iOS, web và test không có (`createAdService` trong
`lib/main.dart`).

| Loại | Khi nào |
|---|---|
| Có thưởng | Kho gợi ý / gậy phép hết: badge hiện icon quảng cáo, bấm là phát quảng cáo, xem xong dùng luôn một lượt (xem [docs/gameplay_rules.md](docs/gameplay_rules.md)) |
| Xen kẽ | Bấm "Màn tiếp" / "Trang chính" ở màn hoàn thành, nếu đã qua 5 phút kể từ quảng cáo xen kẽ trước đó (quảng cáo có thưởng không tính), hoặc từ lúc mở app nếu chưa có quảng cáo nào (`lib/ads/interstitial_policy.dart`) |

- Khi mở app, SDK hỏi ý kiến đồng ý theo GDPR (UMP, chỉ ở vùng bắt buộc).
  Người dùng ở các vùng đó thấy thêm nút **Quyền riêng tư quảng cáo** trong
  Cài đặt.
- Không có mạng / quảng cáo chưa tải xong: bấm vào báo chưa sẵn sàng, không
  trừ gì; khe quảng cáo tự tải lại (giãn cách 10 s → ~5 phút).

### Kiến trúc (`lib/ads/`)

```
Game ──AdPlacement──▶ AdService (ad_service.dart)
                         │  AdManager: đồng ý → tần suất → đã tải?
                         ▼
                      AdNetwork (network/ad_network.dart)
                         │  ConsentGate + FullScreenAdSlot cho mỗi dạng
                         ▼
                      AdMobNetwork (network/admob/) ──▶ đấu giá / mediation
```

- Game chỉ biết **vị trí** (`AdPlacement`: `hint_refill`, `wand_refill`,
  `level_complete`), không biết mạng quảng cáo nào.
- **Bật đấu giá trên AdMob:** cấu hình mediation group / bidding trên web
  AdMob và thêm package adapter `gma_mediation_*` (Meta, AppLovin, Unity,
  Pangle...). Không phải sửa code game.
- **Đổi sang AppLovin MAX / LevelPlay:** viết một `AdNetwork` mới (consent +
  slot) rồi đổi một dòng trong `createAdService`.
- **Doanh thu:** mỗi lượt hiển thị phát `AdPaid` (giá trị, tiền tệ, nguồn
  thắng thầu, vị trí) qua `AdEventSink`; hiện chỉ ghi log khi debug, sau này
  nối Firebase Analytics / AppsFlyer bằng một sink mới.
- **Cấu hình** (`AdConfig`, `InterstitialPolicyConfig`) tách khỏi code, sẵn
  sàng đọc từ Remote Config.
- **ID quảng cáo:** bản `store` dùng ID thật của Nonopix, bản `dev` dùng ID
  thử nghiệm của Google (luôn hiện quảng cáo mẫu, không ra tiền). ID đơn vị
  quảng cáo ở `lib/ads/ad_config.dart`, App ID ở `android/app/build.gradle.kts`
  (theo flavor).
- Thử quảng cáo trên máy: `flutter run --flavor dev`. Chạy `--flavor store`
  là **quảng cáo thật**: đừng bấm vào, AdMob sẽ khoá tài khoản vì lượt bấm
  không hợp lệ; muốn thử bản store thì thêm máy vào **Cài đặt → Thiết bị thử
  nghiệm** trong AdMob trước.

- **Privacy policy:** `docs/privacy/index.html`, đăng bằng GitHub Pages tại
  https://vubaochau-coder.github.io/nonogram/privacy/ (Settings → Pages →
  Deploy from a branch → `main` / `/docs`). Dùng URL này cho Play Console và
  thông báo GDPR trên AdMob. Thêm SDK / dữ liệu mới thì cập nhật trang này.

## Gói "Chơi không quảng cáo"

Chỉ trên Android (`lib/premium/`), mua một lần qua Google Play, mã sản phẩm
**`remove_ads`** (tạo trong Play Console → Kiếm tiền → Sản phẩm trong ứng
dụng). Thẻ mua nằm trên trang chính, hiện giá theo tiền của người dùng; cửa
hàng không dùng được hoặc chưa có sản phẩm thì ẩn.

- Tắt quảng cáo xen kẽ (`AdEntitlements`); quảng cáo có thưởng vẫn còn để
  lấy thêm lượt.
- Quà hằng ngày: kho được nạp lên tối thiểu 2 gợi ý và 1 gậy phép (không
  cộng dồn, ngày không chơi thì mất). Nhận khi mở app, khi mở lại app sau khi
  để nền, và ngay khi mua.
- Chống chỉnh giờ (`DailyRewardPolicy`): "hôm nay" theo giờ mạng (header
  `Date` từ `https://www.google.com/generate_204`), mất mạng mới dùng giờ máy;
  cộng thêm bánh cóc: chỉ phát khi sang ngày mới hơn cả ngày đã phát lẫn ngày
  muộn nhất từng thấy, nên lùi giờ không được gì, vặn tới chỉ vay trước.
- Trạng thái đã mua lưu trên máy (dùng được khi mất mạng), đối chiếu lại với
  Google Play mỗi lần mở app: tự khôi phục khi cài lại, thu hồi khi đã hoàn
  tiền. Mọi giao dịch được xác nhận (`completePurchase`), nếu không Google sẽ
  tự hoàn tiền sau 3 ngày.
- Thử mua thật: tải bản build lên kênh thử nghiệm nội bộ, thêm tài khoản vào
  License testing trong Play Console.

## Đánh giá app

Chỉ trên Android (`lib/rating/`). Khi bấm "Màn tiếp" / "Trang chính" ở màn
hoàn thành, nếu đến lúc thì hiện hộp thoại chọn 1–5 sao, và lần đó không hiện
quảng cáo xen kẽ.

- Lần đầu sau 5 màn đã giải. "Để sau" thì hỏi lại sau 15 màn nữa, tối đa 3
  lần (`RatingPolicy`).
- 5 sao: mở trang app trên CH Play (`market://`, không có thì mở trang web).
  Ít hơn: cảm ơn và ở lại trong game. Đã chọn sao thì không hỏi nữa.

## Phát hành (Firebase App Distribution)

Chỉ phát hành qua GitHub Actions. App Android `com.chauvb.nonogram`
(**Nonopix**) nằm chung project Firebase với app chess (`chess-app-chauvb`).

- Workflow `CI` chạy format/analyze/test cho mỗi push và pull request.
- Workflow `Distribute` build APK release và đẩy lên Firebase App
  Distribution sau khi CI trên `main` xanh, hoặc chạy tay từ tab Actions
  (có ô nhập ghi chú phát hành).
- Số build = số thứ tự lần chạy của workflow `Distribute`, tự tăng mỗi lần
  phát hành.

Secrets/variables cần cấu hình được mô tả ở đầu
`.github/workflows/distribute.yml`.

### Logo

`tools/generate_icons.py` vẽ lại toàn bộ launcher icon, splash, icon web và
`assets/branding/logo.png` (logo 1024px để dùng cho Firebase/store).
