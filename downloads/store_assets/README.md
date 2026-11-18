# Ảnh trang nhà phát triển trên Google Play (chauvb.dev)

Hai script tạo ảnh cho trang nhà phát triển trên Google Play Console
(**Thiết lập → Trang nhà phát triển**).

| Script      | File xuất ra                          | Dùng cho                  | Yêu cầu của Google Play                 |
|-------------|---------------------------------------|---------------------------|-----------------------------------------|
| `icons.js`  | `play-developer-icon-512.png`         | Biểu tượng nhà phát triển | 512×512, JPEG/PNG 24-bit, ≤ 1 MB, không nền trong suốt |
| `header.js` | `play-developer-header-4096x2304.png` | Hình ảnh tiêu đề          | 4096×2304, JPEG/PNG 24-bit, ≤ 1 MB      |

## Thiết kế

- **Biểu tượng:** mặt pixel `>_c` trên nền màn hình CRT đen, chữ xanh phosphor `#00FF66`.
  `>` là mắt nheo / dấu nhắc lệnh, `_` là miệng / con trỏ, `c` là mắt / chữ cái đầu của chauvb.
  Google Play cắt icon thành hình tròn, nên mặt được thu nhỏ để nằm gọn trong vòng tròn.
- **Hình tiêu đề:** mặt `>_c` và chữ `chauvb.dev`, `// indie games & apps` ở giữa, nền tối có vạch
  quét mờ. Mọi chi tiết quan trọng nằm ở khoảng giữa vì điện thoại cắt bớt hai bên.

## Cài đặt (một lần)

Cần Node.js 18+ và font **JetBrains Mono** cài trên máy (tải ở https://www.jetbrains.com/lp/mono/).

```bash
cd downloads/store_assets
npm i playwright
npx playwright install chromium
```

## Tạo ảnh

```bash
node icons.js    # → play-developer-icon-512.png
node header.js   # → play-developer-header-4096x2304.png
```

Ảnh được lưu vào thư mục đang đứng khi chạy lệnh.

## Chỉnh sửa

- **Hình mặt:** mảng `G` ở đầu mỗi script (`X` = ô sáng). Sửa ở cả hai file cho khớp nhau.
- **Màu:** tìm `#00FF66` (xanh phosphor) và `#020A04` / `#020704` (nền).
- **Kích thước mặt trong icon:** `const cell=21,gap=5` trong `icons.js`. Tăng lên thì mặt to hơn
  nhưng dễ bị cắt khi hiện hình tròn.
- **Chữ trên hình tiêu đề:** tìm `chauvb.dev` và `// indie games &amp; apps` trong `header.js`.
- **Dung lượng hình tiêu đề:** ảnh PNG chụp thẳng khoảng 4,5 MB, nên script nén qua JPEG
  `quality:70` trước rồi mới lưu PNG (khoảng 930 KB). Nếu sau khi chỉnh mà file vượt 1 MB, hạ số
  `quality`.

`icons.js` vẫn giữ mã của 2 mẫu không dùng (A: cửa sổ terminal, B: gradient của Pixel Nonogram);
chỉ mẫu C được xuất ra.
