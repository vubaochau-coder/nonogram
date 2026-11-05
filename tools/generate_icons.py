"""Vẽ lại launcher icon, splash và favicon cho app Nonogram.

Chạy: python3 tools/generate_icons.py   (cần Pillow)

Hình: một lưới nonogram 7x6 vẽ trái tim (màn 1), ô tô màu trắng trên nền xanh.
"""
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
BLUE = (9, 105, 218, 255)  # primary của AppTheme.lightTheme
WHITE = (255, 255, 255, 255)
FAINT = (255, 255, 255, 56)
# ImageDraw ghi đè pixel chứ không trộn màu, nên trên nền xanh dùng sẵn màu đã trộn.
FAINT_ON_BLUE = tuple(round(b + (255 - b) * 56 / 255) for b in BLUE[:3]) + (255,)
SPLASH_BG = "#F6F8FA"

HEART = [
    ".##.##.",
    "#######",
    "#######",
    ".#####.",
    "..###..",
    "...#...",
]


def draw_grid(size, art_fraction, background, rounded=False):
    """Ảnh vuông `size`, lưới chiếm `art_fraction` cạnh, ở giữa."""
    scale = 4  # vẽ to rồi thu nhỏ cho mịn
    s = size * scale
    img = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    if background is not None:
        if rounded:
            d.rounded_rectangle([0, 0, s - 1, s - 1], radius=int(s * 0.22), fill=background)
        else:
            d.rectangle([0, 0, s, s], fill=background)

    rows, cols = len(HEART), len(HEART[0])
    cell = s * art_fraction / cols
    gap = cell * 0.12
    x0 = (s - cell * cols) / 2
    y0 = (s - cell * rows) / 2
    for r, line in enumerate(HEART):
        for c, ch in enumerate(line):
            x = x0 + c * cell
            y = y0 + r * cell
            d.rounded_rectangle(
                [x + gap, y + gap, x + cell - gap, y + cell - gap],
                radius=cell * 0.18,
                fill=WHITE if ch == "#" else (FAINT if background is None else FAINT_ON_BLUE),
            )
    return img.resize((size, size), Image.LANCZOS)


def save(img, path, rgb=False):
    path = ROOT / path
    if rgb:
        flat = Image.new("RGB", img.size, BLUE[:3])
        flat.paste(img, mask=img.split()[3])
        img = flat
    img.save(path)


def main():
    res = "android/app/src/main/res"
    for density, px in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
        save(draw_grid(px, 0.62, BLUE), f"{res}/mipmap-{density}/ic_launcher.png", rgb=True)
        adaptive = px * 108 // 48
        save(Image.new("RGBA", (adaptive,) * 2, BLUE), f"{res}/mipmap-{density}/ic_launcher_background.png")
        # Vùng an toàn của adaptive icon là 66/108 ở giữa.
        save(draw_grid(adaptive, 0.40, None), f"{res}/mipmap-{density}/ic_launcher_foreground.png")

    for density, px in {"mdpi": 160, "hdpi": 240, "xhdpi": 320, "xxhdpi": 480, "xxxhdpi": 640}.items():
        save(draw_grid(px, 0.62, BLUE, rounded=True), f"{res}/drawable-{density}/splash_logo.png")
        icon = px * 288 // 160
        # Android 12+: icon splash bị cắt tròn, giữ hình trong 2/3 ở giữa.
        canvas = Image.new("RGBA", (icon, icon), (0, 0, 0, 0))
        logo = draw_grid(int(icon * 0.5), 0.62, BLUE, rounded=True)
        canvas.paste(logo, ((icon - logo.width) // 2,) * 2, logo)
        save(canvas, f"{res}/drawable-{density}/splash_icon.png")

    ios = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    for f in (ROOT / ios).glob("Icon-App-*.png"):
        px = Image.open(f).size[0]
        save(draw_grid(px, 0.62, BLUE), f"{ios}/{f.name}", rgb=True)
    for name, px in {"LaunchImage.png": 160, "LaunchImage@2x.png": 320, "LaunchImage@3x.png": 480}.items():
        save(draw_grid(px, 0.62, BLUE, rounded=True), f"ios/Runner/Assets.xcassets/LaunchImage.imageset/{name}")

    save(draw_grid(32, 0.75, BLUE, rounded=True), "web/favicon.png")
    for px in (192, 512):
        save(draw_grid(px, 0.62, BLUE, rounded=True), f"web/icons/Icon-{px}.png")
        save(draw_grid(px, 0.45, BLUE), f"web/icons/Icon-maskable-{px}.png")

    (ROOT / f"{res}/values/colors.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
        f'    <color name="splash_background">{SPLASH_BG}</color>\n</resources>\n'
    )


if __name__ == "__main__":
    main()
