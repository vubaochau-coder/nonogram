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
   - `pixel`: pixel art (Pixelarticons, Streamline Pixel với `grid: 42`), lấy đúng từng điểm ảnh rồi
     gộp khối 2×2 nếu ảnh vẽ bằng khối 2×2. Bản `solid`
     lấp kín phần bên trong nét viền.
   - Ảnh vector (game-icons, `mode: "emoji"`): thử các cỡ 15/20/25 và ba kiểu chuyển sang đen trắng:
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
| Streamline Pixel | CC BY 4.0 | Ghi công "Streamline" + link giấy phép trong app |
| Game-icons.net | CC BY 3.0 | Ghi công "Lorc, Delapouite & contributors, game-icons.net" + link giấy phép |

Đã thử và bỏ Noto Emoji: emoji màu nhận ra nhờ màu sắc và đổ bóng, chuyển
sang đen trắng 15–25 ô thì không còn nhận ra được. Nên dùng icon vốn vẽ một
màu (hình bóng) hoặc pixel art.

## Trang chọn màn (chọn tay từng ảnh)

`picker/index.html` là trang duyệt từng ảnh, đăng trên claude.ai (riêng tư).
Trang đọc `out/picker_icons.json` (đăng kèm dưới tên `icons.json`) và lưu
từng lựa chọn vào cơ sở dữ liệu của trang (collection `picks`).

Bộ icon PNG (mỗi icon một file, nét đen) nạp vào trang bằng
`import_png_icons.mjs`. Ví dụ bộ 1-bit Pixel Icons của Nikoichu (CC0,
https://nikoichu.itch.io/pixel-icons), bỏ các nhóm logo/giao diện:

```bash
node tools/image_levels/import_png_icons.mjs <thư mục Sprites> --set=nikoichu-1bit \
  --author="1-bit Pixel Icons (Nikoichu)" --license=CC0-1.0 \
  --exclude=Platforms,Software,Controller,Arrows --exclude-words=tetris \
  --include=Platforms_Linux_GNU_Penguin_Full,Platforms_Linux_GNU_Penguin_Head \
  --titles="Platforms_Linux_GNU_Penguin_Full:Tux,Platforms_Linux_GNU_Penguin_Head:Tux Head" \
  --only
```

`--only` bỏ các bộ khác khỏi trang chọn màn (hiện trang chỉ còn bộ của
Nikoichu). Các màn đã chọn từ Pixelarticons/Streamline Pixel vẫn nằm trong
`data/picks.json` nên không mất khi sinh lại bộ màn.

Tux (chim cánh cụt Linux) là ngoại lệ trong nhóm logo: Larry Ewing cho phép dùng
và sửa hình với điều kiện ghi công "Larry Ewing (lewing@isc.tamu.edu) and The
GIMP". Nếu chọn màn Tux, phải thêm ghi công này vào trang Giấy phép.

Duyệt xong, xuất các bản ghi `picks` thành file JSON rồi chạy:

```bash
node tools/image_levels/picks_to_levels.mjs <thư mục picks>
dart run tools/build_levels.dart tools/image_levels/out/levels.json
```
