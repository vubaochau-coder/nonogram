# Nonogram

Game nonogram (tô ô theo gợi ý số để lộ ra hình) viết bằng Flutter, tách ra từ
project Nexora. **Chạy offline hoàn toàn**: màn chơi đóng gói sẵn trong app,
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

## Cấu trúc

```
lib/
  main.dart                  Khởi tạo Hive, repository, MaterialApp
  core/                      Theme, điều hướng (AppRouteIntent), tiện ích dùng chung
  data/
    nonogram_puzzle_source.dart   Đọc màn chơi từ assets/levels/
    hive_nonogram_local_service.dart  Lưu ván dở + màn đã hoàn thành
    nonogram_repository.dart      Gom dữ liệu màn chơi + tiến độ, logic campaign
  models/                    Puzzle, snapshot ván dở, kết quả hoàn thành
  screens/
    dashboard/               Màn chính: chơi tiếp / thử thách tiếp theo, thống kê
    play/                    Gameplay (bloc, engine, solver, UI)
    history/                 Danh sách + chi tiết màn đã hoàn thành
    guide/                   Hướng dẫn cách giải
    painters/                CustomPainter cho lưới, gợi ý, đáp án
  l10n/                      Chuỗi dịch (app_en.arb, app_vi.arb)
assets/
  levels/                    Dữ liệu màn chơi (sinh bằng tools/build_levels.dart)
  guide/                     Ảnh minh hoạ hướng dẫn
tools/
  build_levels.dart          Dump Supabase -> assets/levels/, kiểm tra nghiệm duy nhất
  sample_puzzles.json        10 màn mẫu
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

## Phát hành

Giống `game-2048`: workflow `CI` chạy format/analyze/test; `Distribute` build
APK và đẩy lên Firebase App Distribution sau khi CI trên `main` xanh. Cần cấu
hình secrets/variables như mô tả ở đầu `.github/workflows/distribute.yml`
(app Android mới `com.chauvb.nonogram` cần `FIREBASE_APP_ID` riêng).
