# Định dạng dữ liệu màn chơi

Màn chơi được đóng gói trong app ở `assets/levels/`, không tải gì qua mạng.
Không sửa tay các file này; sinh lại bằng `tools/build_levels.dart`.

## `assets/levels/index.json`

```json
{
  "version": 1,
  "totalLevels": 250,
  "packs": [
    { "file": "pack_001.json", "firstLevel": 1, "lastLevel": 100 },
    { "file": "pack_002.json", "firstLevel": 101, "lastLevel": 200 },
    { "file": "pack_003.json", "firstLevel": 201, "lastLevel": 250 }
  ]
}
```

- Các gói phải phủ liên tục level `1..totalLevels`, không hổng, không chồng.
- App chỉ đọc `index.json` lúc đầu; mỗi gói được đọc khi cần tới level trong
  gói đó rồi giữ trong bộ nhớ (`AssetNonogramPuzzleSource`).

## `assets/levels/pack_XXX.json`

Mỗi màn nằm trên một dòng để diff trên git dễ đọc:

```json
{"version":1,"puzzles":[
{"id":"src-77910","level":1,"title":"Heart","author":"…","difficulty":"3/10","difficultyScore":0.3,"rows":6,"cols":7,"solution":["0110110","1111111","1111111","0111110","0011100","0001000"]}
]}
```

| Trường | Bắt buộc | Ý nghĩa |
|---|---|---|
| `id` | có | ID ổn định của màn, lưu vào snapshot/tiến độ. `src-<source_puzzle_id>` nếu có, không thì `L0001`… |
| `level` | có | Số thứ tự, bắt đầu từ 1 |
| `solution` | có | Mỗi hàng là một chuỗi `0`/`1` (`1` = ô được tô), các hàng dài bằng nhau |
| `rows`, `cols` | không | Nếu có thì phải khớp với `solution` |
| `title`, `author`, `difficulty`, `difficultyScore` | không | Hiển thị trên UI; `title` trống thì dùng `Level N` |

**Không lưu gợi ý (clue).** `topClues`/`leftClues` được tính lại từ
`solution` khi đọc (`NonogramPuzzle.deriveClues`), nên không bao giờ lệch đáp án.

## Sinh dữ liệu

```bash
dart run tools/build_levels.dart path/to/puzzles.json
```

Đầu vào là dump bảng `puzzles` của Supabase: file CSV export từ SQL Editor,
mảng JSON, hoặc `{"data": [...]}`.
`solution` có thể là ma trận số như cột jsonb trên Supabase, hoặc mảng chuỗi.
Script sẽ:

1. Sắp xếp theo `level`, kiểm tra không trùng level/id.
2. Kiểm tra từng màn hợp lệ và **có đúng một nghiệm** (`NonogramSolver`).
   Màn có nhiều nghiệm thì người chơi có thể tô ra hình khác đáp án mà vẫn
   khớp mọi gợi ý.
3. Ghi `index.json` và các `pack_XXX.json` (mặc định 100 màn/gói).

Tuỳ chọn hay dùng:

- `--status=published`: chỉ lấy các màn có status này.
- `--renumber`: đánh số lại liên tục từ 1 (khi lọc bớt làm level bị hổng).
- `--drop-invalid`: bỏ màn lỗi/không duy nhất thay vì dừng (nên kèm `--renumber`).
- `--pack-size=N`: số màn mỗi gói.

`test/data/level_assets_test.dart` chạy lại toàn bộ các kiểm tra trên với
assets đã commit, nên CI sẽ chặn dữ liệu hỏng.

> Dữ liệu hiện tại: **574 màn** sinh từ `tools/data/puzzles_dump.csv` (export
> bảng `puzzles` trên Supabase ngày 2026-11-05, mọi màn đều `status = draft`).
> Sinh lại bằng:
>
> ```bash
> dart run tools/build_levels.dart tools/data/puzzles_dump.csv
> ```

## Thay đổi dữ liệu sau khi đã phát hành

Tiến độ người chơi lưu theo `level` (và `id` trong snapshot ván dở). Vì vậy:

- Thêm màn mới **vào cuối** là an toàn.
- Không đổi thứ tự hay xoá màn đã phát hành: người chơi sẽ thấy "đã hoàn
  thành" ở màn khác với màn họ đã chơi. Nếu buộc phải làm, cần thêm bước
  migrate tiến độ theo `id`.
- Snapshot ván dở có `id` không khớp màn hiện tại sẽ bị bỏ qua
  (`NonogramEngine` kiểm tra `snapshot.puzzleId == puzzle.id`).
