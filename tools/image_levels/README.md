# Sinh màn từ bộ icon mở giấy phép

Công cụ chuyển icon có giấy phép dùng thương mại (lấy từ các gói
`@iconify-json/*` trên npm) thành màn nonogram, để thay bộ màn lấy từ
nonogram.org (không được dùng thương mại).

```bash
npm install --prefix tools/image_levels      # lần đầu (Playwright + Chromium)
npx --prefix tools/image_levels playwright install chromium
node tools/image_levels/generate.mjs
```

Kết quả ở `tools/image_levels/out/`:

- `levels.json`: đầu vào cho `dart run tools/build_levels.dart`.
- `sources.json`: nguồn, phiên bản và giấy phép của từng màn. Giữ file này
  để ghi công và chứng minh nguồn gốc.
- `preview.html` (không commit): hình gốc đặt cạnh mọi biến thể đã thử, kèm
  bản được chọn.

## Cách làm

1. Vẽ SVG trong Chromium (Playwright) rồi lấy mẫu theo ô:
   - `pixel`: pixel art (Pixelarticons), lấy đúng từng điểm ảnh. Bản `solid`
     lấp kín phần bên trong nét viền.
   - Emoji màu (Noto): thử các cỡ 15/20/25 và ba kiểu chuyển sang đen trắng:
     - `silhouette`: hình bóng;
     - `ink`: ô tối hơn ngưỡng Otsu;
     - `cutout`: hình bóng đục lỗ ở các chi tiết tối.
2. Dọn nhiễu: bỏ ô tô lẻ loi, lấp lỗ trống lẻ loi.
3. Chỉ giữ màn **giải được hoàn toàn bằng suy luận hàng/cột**, không cần đoán.
   Điều kiện này mạnh hơn "có đúng một nghiệm". Nếu chưa đạt, công cụ lật tối
   đa khoảng 3% số ô nằm trên mép hình để màn giải được. Các ô bị lật được tô
   đỏ trong preview.
4. Loại màn quá thưa (dưới 25% ô tô) hoặc quá đặc (trên 75%).
5. Chấm điểm các biến thể còn lại và chọn bản tốt nhất:
   - ưu tiên bản có chi tiết, cỡ 20;
   - trừ điểm mảng vụn và số ô phải lật.
6. Xếp level theo độ khó.

## Chỉnh tay

Duyệt bằng `preview.html`, rồi sửa `selection.json`:

- Xoá dòng của hình xấu.
- Thêm `"variant": "silhouette", "size": 20` để ép chọn một bản cụ thể.
- Thêm `"title"` để đặt tên màn.

**Không đưa logo hay nhãn hiệu** (GitHub, Discord…) vào danh sách, dù bộ icon
có sẵn.

## Giấy phép các bộ đang dùng

| Bộ | Giấy phép | Yêu cầu |
|---|---|---|
| Pixelarticons | MIT | Kèm thông báo giấy phép MIT trong app |
| Noto Emoji | Apache 2.0 | Kèm thông báo giấy phép Apache 2.0 trong app |

## Trang chọn màn (chọn tay từng ảnh)

`picker/index.html` là trang duyệt từng ảnh, đăng trên claude.ai (riêng tư).
Trang đọc `out/picker_icons.json` (đăng kèm dưới tên `icons.json`) và lưu
từng lựa chọn vào cơ sở dữ liệu của trang (collection `picks`).

Duyệt xong, xuất các bản ghi `picks` thành file JSON rồi chạy:

```bash
node tools/image_levels/picks_to_levels.mjs <thư mục picks>
dart run tools/build_levels.dart tools/image_levels/out/levels.json
```
