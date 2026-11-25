# Quy ước code và quy trình

Áp dụng cho mọi thay đổi trên repo này, kể cả khi dùng công cụ AI. Các quy
ước này giống dự án chị em [Pixel Akari](https://github.com/vubaochau-coder/akari)
(`docs/roadmap.md` mục 2). Sửa quy ước chung thì sửa ở cả hai repo.

## Git

- **Tên nhánh không chứa tên AI** (`claude`, `copilot`, `gpt`, `cursor`…,
  không phân biệt hoa thường). Đặt tên theo nội dung: `feat/...`, `fix/...`,
  `refactor/...`, `chore/...`, `ci/...`, `docs/...`, `test/...`. Workflow
  `Branch name` chặn pull request từ nhánh vi phạm.
- `main` là bản store, `develop` là bản thử nội bộ. Nhánh phụ tạo từ nhánh
  đích và mở pull request vào đó; nhánh phụ tự xoá sau khi merge.
- Commit message theo Conventional Commits, **tiếng Anh**: `feat`, `fix`,
  `refactor`, `docs`, `chore`, `test`, `ci`, `perf`, `style`; có thể kèm
  phạm vi: `fix(play): …`, `feat(checkin): …`.
- Mỗi pull request làm một việc. Đổi tên / chuyển file tách riêng khỏi thay
  đổi logic để dễ review.

## Ngôn ngữ

- Tên biến, hàm, class: tiếng Anh.
- Tài liệu (`README.md`, `docs/`): tiếng Việt.
- Comment trong code: tiếng Anh cho code mới. Comment tiếng Việt có sẵn giữ
  nguyên, không cần dịch.

## Độ dài và cấu trúc

- Mỗi file Dart trong `lib/`, `test/`, `tools/` **tối đa 300 dòng**. Không
  tính file sinh tự động (`*.g.dart`, `lib/l10n/app_localizations*.dart`).
  Vượt ngưỡng thì tách widget con, tách nhóm logic hoặc tách nhóm test.
- Các file có trước quy ước nằm trong
  [`tools/conventions_baseline.txt`](../tools/conventions_baseline.txt) kèm
  số dòng hiện tại: được ngắn đi, **không được dài thêm**. Tách xong dưới 300
  dòng thì xoá dòng đó khỏi danh sách. **Không thêm file mới vào danh sách.**
- Mỗi hàm tối đa **50 dòng** (mục tiêu 40), lồng khối không quá **3 tầng**;
  ưu tiên early return. Chưa có công cụ kiểm tra tự động: review khi đọc code.

## Tách engine khỏi UI

- `lib/engine/` là lõi game (model puzzle / trạng thái ô, luật, solver):
  **Dart thuần**, cấm `package:flutter/...`, `dart:ui` và mọi file `lib/`
  nằm ngoài `engine/`. Kiểu của Flutter (`Size`, `Offset`, `Axis`…) không
  dùng trong engine; hình học hiển thị nằm ở `screens/play/layout/`.
- `tools/` chỉ dùng `lib/engine/` trong code của app.
- `lib/models/` chứa dữ liệu trạng thái của app (snapshot ván dở, tiến độ,
  kho gợi ý).

## Đặt tên

- Chuẩn Dart: file / thư mục `snake_case`, class / enum `PascalCase`, biến /
  hàm `camelCase`.
- Màn hình đặt tên `*_screen.dart` (class `...Screen`), widget thành phần
  `*_widget.dart` hoặc nằm trong `widgets/` / `sections/`. Không dùng
  `*_page.dart` (`check_conventions` chặn).
- Từ vựng game dùng thống nhất, không thay bằng từ đồng nghĩa:

| Khái niệm | Trong code |
|---|---|
| Bàn chơi / ô | `board` / `cell` (`row`, `col`) |
| Dãy số gợi ý của hàng / cột | `clue` |
| Ô đã tô / ô đánh X / ô trống | `filled` / `marked` / `empty` (`NonogramCellState`) |
| Chế độ chạm tô / đánh X | `fill` / `mark` (`NonogramInteractionMode`) |
| Màn chơi (dữ liệu) | `puzzle` |
| Ván dở đã lưu | `snapshot` |
| Gợi ý mở ô / gậy phép | `hint` / `wand` |
| Ô đã khoá (mở bằng gợi ý, gậy phép) | `locked` |
| Ô cho sẵn trong dữ liệu màn | `pinned` |

## Kiểm tra trước khi push

```bash
dart format --output=none --set-exit-if-changed lib test tools
flutter analyze
dart run tools/check_conventions.dart
flutter test
```

Tất cả phải sạch / pass (`flutter analyze` 0 issue). CI chạy đúng các bước
này cho mọi push / pull request vào `develop`, `Store build` chạy lại trên
`main`.
