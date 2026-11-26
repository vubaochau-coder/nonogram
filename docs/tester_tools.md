# Công cụ tester

Chỉ có ở bản build `--flavor dev` (bản `store` không có). Mở: tab **Tôi →
Tester → Công cụ tester**.

| Mục | Dùng để test |
| --- | --- |
| **Ngày & điểm danh** | Tua giờ của game ±1 / +7 ngày (không đổi giờ điện thoại), điểm danh liền nhiều ngày tới quà mốc, xoá dữ liệu điểm danh. Lượt trong ngày của gói premium cũng hết hạn theo ngày đã tua. Lùi ngày thì tự gỡ chặn chống chỉnh giờ. |
| **Gói không quảng cáo** | Chọn **Cửa hàng giả** (mặc định, không tốn tiền) hoặc **Google Play** thật. Với cửa hàng giả: chọn kết quả khi bấm mua (thành công / chờ thanh toán / huỷ / lỗi), hoàn tất giao dịch chờ, coi như đã mua, giả lập hoàn tiền (thu hồi gói). |
| **Màn chơi** | Nút ⚡ **Giải ngay** trên thanh tiêu đề màn chơi (màn ngang: cột trái): tô đúng đáp án, hoàn thành màn như khi tự giải (lưu tiến độ, hiệu ứng, màn kết quả). |
| **Kho gợi ý / gậy phép** | +10 gợi ý, +10 gậy phép, hoặc đưa về 0 để test nút xem quảng cáo có thưởng. |
| **Quảng cáo & đánh giá** | Bỏ giãn cách 5 phút của quảng cáo xen kẽ; đặt lại lời mời đánh giá (hỏi lại từ màn đã giải thứ 5). |

Cài đặt tester lưu trong box Hive riêng `nonogram_tester_v1`, không lẫn với
dữ liệu người chơi.

## Test với Google Play thật

1. Play Console → Cài đặt → **Thử nghiệm giấy phép**: thêm Gmail của tester.
2. Sản phẩm trong ứng dụng `remove_ads` phải đang hoạt động.
3. Cài app từ kênh **Thử nghiệm nội bộ**, chọn **Google Play** trong công cụ
   tester rồi mua bằng "thẻ thử nghiệm".
4. Muốn mua lại: Play Console → **Quản lý đơn hàng** → hoàn tiền và thu hồi
   đơn thử, rồi mở lại app.
