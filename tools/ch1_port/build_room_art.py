import json
import shutil
from pathlib import Path

from PIL import Image, ImageOps


ROOT = Path(__file__).resolve().parents[2]
PORT = ROOT / "tools" / "ch1_port"
RAW = PORT / "raw"
ROOM_OUT = ROOT / "assets" / "sprites" / "world" / "ch1_dark" / "rooms"
SPRITE_OUT = ROOT / "assets" / "sprites" / "world" / "ch1_dark" / "extracted"
FACE_OUT = ROOT / "assets" / "sprites" / "face"


def tile_image(tile):
    source = RAW / "sprites" / tile["asset"] / "0.png"
    image = Image.open(source).convert("RGBA")
    box = (
        int(tile["source_x"]),
        int(tile["source_y"]),
        int(tile["source_x"] + tile["width"]),
        int(tile["source_y"] + tile["height"]),
    )
    image = image.crop(box)
    scale_x = float(tile["scale_x"])
    scale_y = float(tile["scale_y"])
    if scale_x < 0:
        image = ImageOps.mirror(image)
    if scale_y < 0:
        image = ImageOps.flip(image)
    width = max(1, round(image.width * abs(scale_x)))
    height = max(1, round(image.height * abs(scale_y)))
    if (width, height) != image.size:
        image = image.resize((width, height), Image.Resampling.NEAREST)
    return image


def main():
    manifest = json.loads((PORT / "ch1_rooms.json").read_text(encoding="utf-8"))
    ROOM_OUT.mkdir(parents=True, exist_ok=True)
    SPRITE_OUT.mkdir(parents=True, exist_ok=True)

    for room in manifest["rooms"]:
        canvas = Image.new("RGBA", (int(room["width"]), int(room["height"])), (0, 0, 0, 255))
        for layer in sorted(room["layers"], key=lambda value: value["depth"], reverse=True):
            if layer.get("kind") == "background":
                source = RAW / "sprites" / layer["sprite"] / "0.png"
                image = Image.open(source).convert("RGBA")
                if room["name"] == "room_castle_outskirts" and layer["sprite"] == "bg_darkwest":
                    image = image.resize(canvas.size, Image.Resampling.NEAREST)
                    canvas.alpha_composite(image, (0, 0))
                    continue
                if layer.get("stretch"):
                    image = image.resize(canvas.size, Image.Resampling.NEAREST)

                start_x = int(layer.get("x", 0))
                start_y = int(layer.get("y", 0))
                # Legacy backgrounds are camera-relative. Castle Front is wider
                # than the 640px Chapter 1 camera, so bake it at the centered
                # camera origin instead of pinning the castle to the room's left.
                if room["name"] == "room_castle_front" and layer["sprite"] == "bg_darkcastle_front":
                    start_x = (canvas.width - image.width) // 2
                xs = range(start_x, canvas.width, image.width) if layer.get("tiled_x") else [start_x]
                ys = range(start_y, canvas.height, image.height) if layer.get("tiled_y") else [start_y]
                for x in xs:
                    for y in ys:
                        canvas.alpha_composite(image, (x, y))
                continue

            for tile in layer["tiles"]:
                image = tile_image(tile)
                canvas.alpha_composite(image, (int(tile["x"]), int(tile["y"])))
        canvas.save(ROOM_OUT / f'{room["name"]}.png', optimize=True)

    for source in (RAW / "sprites").iterdir():
        if not source.is_dir():
            continue
        destination = SPRITE_OUT / source.name
        destination.mkdir(parents=True, exist_ok=True)
        for frame in source.glob("*.png"):
            shutil.copy2(frame, destination / frame.name)

    for portrait_name, sprite_name in {
        "ch1_ralsei": "spr_face_r_dark",
        "ch1_lancer": "spr_face_l0",
    }.items():
        destination = FACE_OUT / portrait_name
        destination.mkdir(parents=True, exist_ok=True)
        frames = sorted((RAW / "sprites" / sprite_name).glob("*.png"), key=lambda p: int(p.stem))
        for index, frame in enumerate(frames):
            shutil.copy2(frame, destination / f"{index}.png")
        if frames:
            shutil.copy2(frames[0], destination / "neutral.png")

    susie_destination = FACE_OUT / "ch1_susie"
    susie_destination.mkdir(parents=True, exist_ok=True)
    for index in range(11):
        suffix = str(index) if index < 10 else "A"
        frame = RAW / "sprites" / f"spr_face_s{suffix}" / "0.png"
        if frame.exists():
            shutil.copy2(frame, susie_destination / f"{index}.png")
    if (susie_destination / "0.png").exists():
        shutil.copy2(susie_destination / "0.png", susie_destination / "neutral.png")

    print(f"Built {len(manifest['rooms'])} room images and copied extracted sprite frames.")


if __name__ == "__main__":
    main()
