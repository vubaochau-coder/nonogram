"""Vẽ logo Nonopix: launcher icon (Android, iOS), splash và icon web.

Chạy: python3 tools/generate_icons.py   (cần Pillow)

Hình: nền gradient chàm -> tím (giống thẻ chính trên dashboard), ở giữa là
lưới nonogram 5x5 vẽ trái tim (ô tô màu trắng, ô trống mờ), phía trên và bên
trái có các vạch tượng trưng cho số gợi ý.
"""
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
GRAD_START = (59, 91, 219)  # AppTheme.brand / GameColors.heroStart
GRAD_END = (103, 65, 217)  # GameColors.heroEnd
SPLASH_BG = "#F5F6FA"  # nền trang của app (sáng)

HEART = [
    "01010",
    "11111",
    "11111",
    "01110",
    "00100",
]



def clues(line):
    out, run = [], 0
    for ch in line:
        if ch == "1":
            run += 1
        elif run:
            out.append(run)
            run = 0
    if run:
        out.append(run)
    return out


# Gợi ý thật của hình trái tim; mỗi số vẽ thành một vạch dài theo giá trị.
TOP_CLUES = [clues([row[c] for row in HEART]) for c in range(len(HEART[0]))]
LEFT_CLUES = [clues(row) for row in HEART]

SS = 4  # vẽ to gấp 4 lần rồi thu nhỏ cho mịn


def gradient(size):
    """Gradient chéo; vẽ ở 256px rồi phóng lên (gradient tuyến tính nên mịn)."""
    base = 256
    img = Image.new("RGB", (base, base))
    px = img.load()
    for y in range(base):
        for x in range(base):
            t = (x + y) / (2 * (base - 1))
            px[x, y] = tuple(
                round(a + (b - a) * t) for a, b in zip(GRAD_START, GRAD_END)
            )
    return img.resize((size, size), Image.BICUBIC).convert("RGBA")


def draw_art(size, art_fraction):
    """Lưới + vạch gợi ý trên nền trong suốt, căn giữa, chiếm art_fraction."""
    s = size * SS
    img = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    n = len(HEART)
    # Bố cục: 1.1 "ô" cho vùng gợi ý + 5 ô lưới, theo cả hai chiều.
    clue = 0.95
    units = n + clue
    cell = s * art_fraction / units
    gap = cell * 0.12
    x0 = (s - cell * units) / 2 + cell * clue
    y0 = (s - cell * units) / 2 + cell * clue

    white = (255, 255, 255, 255)
    faint = (255, 255, 255, 48)
    mark = (255, 255, 255, 170)

    for r, row in enumerate(HEART):
        for c, ch in enumerate(row):
            x = x0 + c * cell
            y = y0 + r * cell
            d.rounded_rectangle(
                [x + gap, y + gap, x + cell - gap, y + cell - gap],
                radius=cell * 0.2,
                fill=white if ch == "1" else faint,
            )

    # Vạch gợi ý: mỗi số gợi ý là một vạch, dài theo giá trị của số; vạch
    # dọc phía trên mỗi cột, vạch ngang bên trái mỗi hàng, xếp sát lưới.
    thick = cell * 0.17
    space = cell * 0.12
    max_len = cell * clue - gap * 1.5 - space

    def bar_lengths(values):
        # Chia chỗ theo tỉ lệ giá trị, vạch ngắn nhất vẫn dài hơn độ dày.
        total = max_len - space * (len(values) - 1)
        unit = total / max(5, sum(values))
        return [max(thick * 1.2, v * unit) for v in values]

    for c, values in enumerate(TOP_CLUES):
        cx = x0 + c * cell + cell / 2
        bottom = y0 - gap * 1.5
        for length in reversed(bar_lengths(values)):
            d.rounded_rectangle(
                [cx - thick / 2, bottom - length, cx + thick / 2, bottom],
                radius=thick / 2,
                fill=mark,
            )
            bottom -= length + space
    for r, values in enumerate(LEFT_CLUES):
        cy = y0 + r * cell + cell / 2
        right = x0 - gap * 1.5
        for length in reversed(bar_lengths(values)):
            d.rounded_rectangle(
                [right - length, cy - thick / 2, right, cy + thick / 2],
                radius=thick / 2,
                fill=mark,
            )
            right -= length + space
    return img.resize((size, size), Image.LANCZOS)


def icon(size, art_fraction=0.66, rounded=False, transparent_corners=True):
    bg = gradient(size * SS)
    if rounded:
        mask = Image.new("L", bg.size, 0)
        ImageDraw.Draw(mask).rounded_rectangle(
            [0, 0, bg.width - 1, bg.height - 1], radius=int(bg.width * 0.23), fill=255
        )
        out = Image.new("RGBA", bg.size, (0, 0, 0, 0))
        out.paste(bg, mask=mask)
        bg = out
    bg = bg.resize((size, size), Image.LANCZOS)
    art = draw_art(size, art_fraction)
    bg.alpha_composite(art)
    return bg


def save(img, rel, rgb=False):
    path = ROOT / rel
    if rgb:
        img = img.convert("RGB")
    img.save(path)


def main():
    res = "android/app/src/main/res"
    for density, px in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
        save(icon(px), f"{res}/mipmap-{density}/ic_launcher.png", rgb=True)
        adaptive = px * 108 // 48
        save(gradient(adaptive * SS).resize((adaptive,) * 2, Image.LANCZOS),
             f"{res}/mipmap-{density}/ic_launcher_background.png")
        # Vùng an toàn của adaptive icon là 66/108 ở giữa.
        save(draw_art(adaptive, 0.5), f"{res}/mipmap-{density}/ic_launcher_foreground.png")

    for density, px in {"mdpi": 160, "hdpi": 240, "xhdpi": 320, "xxhdpi": 480, "xxxhdpi": 640}.items():
        save(icon(px, rounded=True), f"{res}/drawable-{density}/splash_logo.png")
        size = px * 288 // 160
        # Android 12+: icon splash bị cắt tròn, giữ hình trong 2/3 ở giữa.
        canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        logo = icon(int(size * 0.5), rounded=True)
        canvas.alpha_composite(logo, ((size - logo.width) // 2,) * 2)
        save(canvas, f"{res}/drawable-{density}/splash_icon.png")

    ios = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    for f in (ROOT / ios).glob("Icon-App-*.png"):
        px = Image.open(f).size[0]
        save(icon(px), f"{ios}/{f.name}", rgb=True)
    for name, px in {"LaunchImage.png": 160, "LaunchImage@2x.png": 320, "LaunchImage@3x.png": 480}.items():
        save(icon(px, rounded=True), f"ios/Runner/Assets.xcassets/LaunchImage.imageset/{name}")

    save(icon(32, art_fraction=0.8, rounded=True), "web/favicon.png")
    for px in (192, 512):
        save(icon(px, rounded=True), f"web/icons/Icon-{px}.png")
        save(icon(px, art_fraction=0.5), f"web/icons/Icon-maskable-{px}.png")

    # Logo lớn để dùng cho Firebase / store / README.
    (ROOT / "assets/branding").mkdir(parents=True, exist_ok=True)
    save(icon(1024, rounded=True), "assets/branding/logo.png")
    save(icon(512), "assets/branding/logo_square_512.png", rgb=True)

    (ROOT / f"{res}/values/colors.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
        f'    <color name="splash_background">{SPLASH_BG}</color>\n</resources>\n'
    )


if __name__ == "__main__":
    main()
