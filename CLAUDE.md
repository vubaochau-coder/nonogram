# Quy tắc cho dự án Pixel Nonogram

Áp dụng cho mọi người và mọi công cụ AI (Claude, Copilot, Cursor...) làm việc
trên repo này.

## Nhánh

- **Tên nhánh không được chứa tên AI**: không dùng `claude`, `anthropic`,
  `copilot`, `chatgpt`, `gpt`, `openai`, `gemini`, `bard`, `cursor`, `codex`,
  `devin`... (không phân biệt hoa thường). Đặt tên theo nội dung thay đổi, ví
  dụ `feat/check-in-streak`, `fix/ad-not-ready-message`, `ci/store-build-tag`.
  Workflow `Branch name` chặn pull request từ nhánh vi phạm.
- `main` là bản phát hành (Store build chạy tay trên nhánh này), `develop` là
  bản thử nội bộ (Firebase App Distribution). Nhánh phụ tạo từ nhánh đích và
  mở pull request vào đó.
- Nhánh phụ được xoá tự động sau khi pull request được merge (cài đặt
  "Automatically delete head branches" của repo). Không giữ lại nhánh đã
  merge.
- Commit message: Conventional Commits, tiếng Anh (`feat`, `fix`,
  `refactor`, `docs`, `chore`, `test`, `ci`, `perf`, `style`).

## Quy ước code (tóm tắt, chi tiết ở [`docs/conventions.md`](docs/conventions.md))

- File ≤ 300 dòng (trừ file sinh tự động), hàm ≤ 50 dòng, lồng khối ≤ 3 tầng.
  File cũ còn vượt ngưỡng nằm trong `tools/conventions_baseline.txt`: chỉ
  được ngắn đi; không thêm file mới vào danh sách.
- Màn hình mới `*_screen.dart`, widget thành phần `*_widget.dart` hoặc trong
  `widgets/` / `sections/`.
- Tên trong code và comment mới bằng tiếng Anh; tài liệu bằng tiếng Việt.
  Comment tiếng Việt có sẵn không cần dịch.
- Dùng đúng từ vựng game trong `docs/conventions.md` (`clue`, `filled`,
  `marked`, `snapshot`, `hint`, `wand`…).

## Trước khi push

```bash
dart format --output=none --set-exit-if-changed lib test tools
flutter analyze
dart run tools/check_conventions.dart
flutter test
```

Tất cả phải sạch / pass.
