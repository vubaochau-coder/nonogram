# Ghi công hình ảnh màn chơi

Các màn chơi trong `assets/levels/` được chuyển từ những bộ icon pixel art
dưới đây (đã thu nhỏ, đổi sang đen trắng và chỉnh sửa vài ô cho giải được).
Nguồn và giấy phép của từng màn nằm trong `tools/image_levels/out/sources.json`.

| Bộ | Tác giả | Giấy phép | Số màn |
|---|---|---|---|
| [Pixelarticons](https://github.com/halfmage/pixelarticons) | Gerrit Halfmann | [MIT](https://github.com/halfmage/pixelarticons/blob/master/LICENSE) | 39 |
| [Streamline Pixel](https://github.com/webalys-hq/streamline-vectors) | Streamline | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) | 82 |

Ngoài ra có 8 màn nonogram dùng nguyên bản (không chuyển từ icon), lấy từ bộ
[nonogram-db](https://github.com/Sprunth/nonogram-db). Dữ liệu ở
`tools/image_levels/data/nonogram_db.json`.

| Màn | Tác giả | Giấy phép |
|---|---|---|
| Dancer, Scaredy Cat, Probably Not, Slippery Conditions (© 2004), Swing (© 2006), từ webpbn.com | Jan Wolter | [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/) |
| Spade, 42 (© 2010), từ gnonograms | Frederico Vera | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) |
| Bloop Bloop (© 2015, webpbn #26167) | Michael Terry | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) |

Các màn CC BY-SA phải tiếp tục để dưới CC BY-SA 4.0. Không dùng các màn GPL
của nonogram-db (nhóm qnonograms) và các màn là logo (Blender, GNOME, KDE,
Ubuntu, Wikimedia).

App hiện nội dung ghi công này ở Cài đặt → Giấy phép (`AppLicensesPage`);
văn bản giấy phép đầy đủ nằm trong `assets/licenses/` và được đăng ký vào trang
giấy phép phần mềm của Flutter:

- "Pixel art icons by Streamline (streamlinehq.com), licensed under CC BY 4.0.
  Modified: converted to nonogram puzzles."
- Thông báo giấy phép MIT của Pixelarticons (Copyright (c) Gerrit Halfmann).

Nếu sau này thêm hình từ game-icons.net (CC BY 3.0), phải ghi công thêm
"Icons by Lorc, Delapouite & contributors, game-icons.net, CC BY 3.0".
