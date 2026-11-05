# Nonopix

<img src="assets/branding/logo.png" width="96" alt="Logo Nonopix">


**Nonopix** là game nonogram (tô ô theo gợi ý số để lộ ra hình) viết bằng
Flutter, tách ra từ project Nexora. **Chạy offline hoàn toàn**: màn chơi đóng gói sẵn trong app,
tiến độ lưu trên máy, không cần tài khoản hay mạng.

## Chạy game

```bash
flutter pub get
flutter run
```

Hỗ trợ Android, iOS và Web. Giao diện có tiếng Việt và tiếng Anh (theo ngôn ngữ máy).

Bản web cần build kèm CanvasKit để chạy được khi không có mạng:

```bash
flutter build web --no-web-resources-cdn
```

## Điều khiển

| Thao tác | Chế độ tô (bút chì) | Chế độ bàn tay |
|---|---|---|
| Chạm | Tô / xoá một ô | – |
| Nhấn giữ | Đánh dấu X | – |
| Kéo một ngón | Tô liên tiếp | Kéo bàn |
| Hai ngón | Kéo bàn, chụm để zoom | Kéo bàn, chụm để zoom |
| Chuột / trackpad | Lăn để kéo, Ctrl/⌘ + lăn hoặc chụm trackpad để zoom | như bên trái |

- Hai dải gợi ý luôn dính mép trái / mép trên khi kéo lưới đi, nên luôn
  thấy gợi ý của hàng/cột đang tô.
- Màn mới tự chọn cỡ ô vừa màn hình (tối thiểu 24px); zoom chỉ áp dụng cho
  màn đang chơi và được lưu cùng ván dở. Thu nhỏ dưới 10px là chế độ xem
  tổng thể (ẩn số gợi ý).
- Ô trống trên hàng/cột đã khớp gợi ý hiện chấm tròn; X màu chàm là dấu
  người chơi tự đánh.

## Cấu trúc

```
lib/
  main.dart                  Khởi tạo Hive, repository, MaterialApp
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
    guide/                   Hướng dẫn cách giải
    painters/                CustomPainter cho lưới, gợi ý, đáp án
  l10n/                      Chuỗi dịch (app_en.arb, app_vi.arb)
assets/
  levels/                    574 màn chơi (sinh bằng tools/build_levels.dart)
  guide/                     Ảnh minh hoạ hướng dẫn
  fonts/                     Font Nunito (giấy phép OFL, xem Nunito-OFL.txt)
tools/
  build_levels.dart          Dump Supabase -> assets/levels/, kiểm tra nghiệm duy nhất
  data/puzzles_dump.csv      Dump bảng puzzles từ Supabase (nguồn của assets/levels/)
  generate_icons.py          Vẽ launcher icon / splash / favicon
docs/
  level_format.md            Định dạng dữ liệu màn chơi
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

## Phát hành (Firebase App Distribution)

App Android `com.chauvb.nonogram` nằm chung project Firebase với app chess
(`chess-app-chauvb`).

### Từ máy cá nhân

```bash
cp scripts/distribute.env.example scripts/distribute.env   # rồi điền nhóm tester
firebase login                                              # một lần
scripts/distribute_android.sh --notes "Sửa lỗi zoom"
```

Script sẽ:

1. Tìm App ID theo package trong project chess. Nếu chưa có app, script hỏi
   rồi tạo app Android **Nonopix** (dùng `--yes` để khỏi hỏi).
2. Chạy `flutter analyze` và `flutter test` (`--skip-tests` để bỏ qua).
3. Build APK release với số build = số thứ tự lần chạy gần nhất của workflow
   Distribute trên GitHub + 1 (đọc qua `gh`; hoặc truyền `--build-number`).
   CI dùng chính số thứ tự lần chạy làm số build, nên bản sau luôn lớn hơn.
4. Upload kèm ghi chú (mặc định là commit mới nhất, có version và commit).

Cần `android/key.properties` trỏ tới **cùng keystore** với secret
`ANDROID_KEYSTORE_BASE64` của CI; thiếu thì script cảnh báo vì APK sẽ ký bằng
debug key và tester không cài đè được. Xem `scripts/distribute_android.sh
--help` cho mọi tuỳ chọn (`--groups`, `--testers`, `--dry-run`…).

### Từ CI

Workflow `CI` chạy format/analyze/test; `Distribute` build APK và đẩy lên
Firebase sau khi CI trên `main` xanh, hoặc chạy tay từ tab Actions. Cần cấu
hình secrets/variables như mô tả ở đầu `.github/workflows/distribute.yml`
(`FIREBASE_APP_ID` lấy từ lần chạy script đầu tiên hoặc Firebase Console).

### Logo

`tools/generate_icons.py` vẽ lại toàn bộ launcher icon, splash, icon web và
`assets/branding/logo.png` (logo 1024px để dùng cho Firebase/store).
