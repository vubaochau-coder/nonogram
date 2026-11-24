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
