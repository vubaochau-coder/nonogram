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
| `pinned` | không | Ô ghim sẵn: danh sách `[hàng, cột]` (đếm từ 0). Ô ghim hiện đúng theo `solution` ngay từ đầu màn (ô tô, hoặc dấu X nếu là ô trống), có chấm ghim tròn và không đổi được. Dùng cho màn có nhiều cách tô khớp gợi ý, để chỉ còn một nghiệm mà không phải sửa hình. Tối đa 5% số ô. |

**Không lưu gợi ý (clue).** `topClues`/`leftClues` được tính lại từ
`solution` khi đọc (`NonogramPuzzle.deriveClues`), nên không bao giờ lệch đáp án.

## Sinh dữ liệu

```bash
dart run tools/build_levels.dart path/to/puzzles.json
```

Đầu vào là mảng JSON (như `tools/image_levels/out/levels.json`), `{"data": [...]}`,
hoặc file CSV có dòng đầu là tên cột.
`solution` có thể là ma trận số hoặc mảng chuỗi `"0101..."`.
Script sẽ:

1. Sắp xếp theo `level`, kiểm tra không trùng level/id.
2. Kiểm tra từng màn hợp lệ và **có đúng một nghiệm** khi đã tính các ô `pinned` (`NonogramSolver`).
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

> Dữ liệu hiện tại: **129 màn** có giấy phép dùng thương mại (xem
> `tools/image_levels/README.md`):
>
> - Pixelarticons (MIT): 39 màn, duyệt tay trên trang chọn màn
> - Streamline Pixel (CC BY 4.0): 82 màn, duyệt tay trên trang chọn màn
> - nonogram-db (CC BY 3.0 / CC BY-SA 4.0): 8 màn dùng nguyên bản
>
> Nguồn và giấy phép của từng màn: `tools/image_levels/out/sources.json`;
> ghi công: `docs/credits.md`. Sinh lại bằng:
>
> ```bash
> node tools/image_levels/picks_to_levels.mjs tools/image_levels/data/picks.json
> dart run tools/build_levels.dart tools/image_levels/out/levels.json
> ```
>
> Bộ màn cũ lấy từ nonogram.org (574 màn) đã bị gỡ vì không được dùng thương mại.

## Bộ màn của chế độ nhà phát triển

`assets/levels_dev/` cùng định dạng, chứa 574 màn cũ lấy từ nonogram.org (bản
chụp `assets/levels/` của nhánh `main` trước khi đổi bộ màn; dữ liệu gốc còn ở
nhánh `beta`). Bộ này chỉ được đóng gói khi build `--flavor dev` và không được
đưa vào bản store. `test/data/level_assets_test.dart` kiểm tra cả hai bộ.

## Thay đổi dữ liệu sau khi đã phát hành

Tiến độ người chơi lưu theo `level` (và `id` trong snapshot ván dở). Vì vậy:

- Thêm màn mới **vào cuối** là an toàn.
- Không đổi thứ tự hay xoá màn đã phát hành: người chơi sẽ thấy "đã hoàn
  thành" ở màn khác với màn họ đã chơi. Nếu buộc phải làm, cần thêm bước
  migrate tiến độ theo `id`.
- Snapshot ván dở có `id` không khớp màn hiện tại sẽ bị bỏ qua
  (`NonogramEngine` kiểm tra `snapshot.puzzleId == puzzle.id`).
