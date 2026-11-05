# Nonogram – Quy tắc gameplay

> Chuyển từ `docs/features/nonogram_closeout_notes.md` của Nexora. Bản offline
> không còn tài khoản/đồng bộ; mọi tiến độ chỉ nằm trên máy (Hive box
> `nonogram_offline_v1`), màn chơi đọc từ `assets/levels/`.

Tài liệu này chốt lại các rule vận hành hiện tại của Nonogram sau giai đoạn polish gần nhất. Mục tiêu là để vài tháng sau quay lại vẫn hiểu nhanh feature đang hoạt động theo logic nào, phần nào là cố ý, và phần nào không nên phá vỡ khi mở rộng.

## Trạng thái feature
- Nonogram đã ở mức usable/playable.
- Flow chính: `Dashboard -> Gameplay -> Dashboard` (app mở thẳng vào Dashboard).
- Test nonogram hiện đang pass ở mức engine + bloc/dashboard logic.

## Campaign Rules
- Progression vẫn là tuyến tính, không có level picker thủ công.
- `nextPlayableLevel` là nguồn sự thật cho câu hỏi: "màn nên chơi tiếp là màn nào?"
- `currentProgress` chỉ đại diện cho **session đang chơi dở thật sự**.
- Snapshot của một level đã nằm trong `completedProgress` được coi là **stale session**.
- Dashboard không được ưu tiên resume snapshot stale; phải fallback về `nextPlayableLevel`.

## Snapshot Rules
- `NonogramBoardSnapshot` chỉ nên được hiểu là state của một ván đang chơi dở.
- Không dùng snapshot như placeholder để đánh dấu "mục tiêu tiếp theo".
- Solve xong level hiện tại thì `clearCurrentProgress()`.
- Không seed snapshot rỗng cho level kế tiếp.

## Hint Rules
- Mỗi màn có `3` lượt gợi ý.
- `remainingHints` được lưu local trong snapshot.
- `BoardReset` không reset quota hint.
- Sang màn mới mà không có snapshot restore thì quota trở về `3`.
- Hint v1 mở **cả line**:
  - `solution == 1 -> filled`
  - `solution == 0 -> marked`
- Hint highlight là UI effect ngắn hạn, không phải persistent state.

## Gameplay / Solve Semantics
- Ô có `solution == 1` chỉ được coi là đúng khi state là `filled`.
- Ô có `solution == 0` được coi là đúng nếu **không phải** `filled`.
- Điều này nghĩa là cả `empty` và `marked` đều hợp lệ về mặt solve.
- Logic chọn line hint đã bám theo semantics solve ở trên; không ép ô `0` phải là `marked` mới được xem là đúng.

## Dashboard Rules
- Nếu có `currentProgress` hợp lệ thì CTA là `Tiếp tục chơi`.
- Nếu không có session dở hợp lệ thì CTA là `Thử thách tiếp theo` với `nextPlayableLevel`.
- Không để dashboard bị kéo ngược về một level cũ chỉ vì local còn snapshot stale.

## UI Structure Notes
- `NonogramBoardShellSection` giữ vai trò layout/orchestration.
- `NonogramHintHighlightOverlay` giữ logic animation, bloc listening, và tính toán vùng highlight.
- Cách tách này là chủ đích để section cha không phải ôm `AnimationController`.

## Những gì chưa làm
- Chưa có integration/widget test sâu cho full navigation flow.
- Chưa có level picker hay replay flow chủ động từ dashboard/history vào gameplay.
- Chưa tối ưu thêm game design của hint beyond v1.

## Nếu quay lại phát triển sau này
- Nếu thêm replay hoặc level picker, phải đọc lại kỹ:
  - `NonogramRepository.getCampaignOverview()`
  - `NonogramPlayBloc._onLevelLoadRequested()`
  - logic stale snapshot vs completed progress
- Nếu thay đổi meaning của snapshot, phải cập nhật lại:
  - dashboard CTA rules
  - docs closeout này
  - regression tests của nonogram dashboard + play bloc

## Regression Cases Quan Trọng
- Dùng hint rồi back ra dashboard phải giữ đúng session dở.
- Snapshot của level đã complete không được làm dashboard resume sai level.
- `BoardReset` không được reset `remainingHints`.
- Sang màn mới phải có `3` hint nếu không restore từ snapshot cùng level.
