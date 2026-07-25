import json
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MANIFEST = json.loads((ROOT / "tools" / "ch1_port" / "ch1_rooms.json").read_text(encoding="utf-8"))
MAP_OUT = ROOT / "scripts" / "world" / "maps"
ROOM_NAMES = [room["name"] for room in MANIFEST["rooms"]]
ROOM_INDEX = {name: index for index, name in enumerate(ROOM_NAMES)}
SPRITES = {sprite["name"]: sprite for sprite in MANIFEST["sprites"]}
DOOR_STEPS = {"A": 1, "B": -1, "C": 2, "D": -2, "E": 3, "F": -3}
GENERIC_VISUALS = {
    "obj_castle_house", "obj_castle_torch", "obj_darkdoorevent",
    "obj_darkeyepuzzle", "obj_npc_room", "obj_npc_facing", "obj_npc_sign",
    "obj_npc_susiedark", "obj_ralsei_runevent", "obj_sul",
    "obj_sur_dark", "obj_wobblything_evil", "obj_npc_room_animated",
    "obj_npc_puzzlemaster1", "obj_npc_puzzlemaster2", "obj_hathyfightevent",
    "obj_shortcut_door",
}


def readable_properties(room_name):
    """Return the original Chapter 1 interaction assigned to a readable object."""
    if room_name in {"room_dark2", "room_dark3", "room_dark7"}:
        return {"text": "* (It's too dark to see anything.)"}
    if room_name == "room_dark_eyepuzzle":
        return {"text": "* In this land,[wait:5] only eyes blinded by darkness can see the way..."}
    if room_name == "room_castle_town":
        return {
            "text": "* (It looks like a shop,[wait:5] but the door is locked,[wait:5] and no one's inside...)",
            "repeat_text": "* (It's locked.)",
            "flag": "ch1_read_castle_town_door",
        }
    if room_name == "room_castle_front":
        return {
            "text": [
                "* Hey,[wait:5] Kris,[wait:5] I really think we should catch up with Susie.",
                "* We can come back here after our adventure is over...",
                "* ... and then I can bake you a yummy cake!",
            ],
            "repeat_text": [
                "* Kris,[wait:5] perhaps we should save the world first...?",
                "* It seems a bit important.",
            ],
            "flag": "ch1_read_castle_front_door",
        }
    if room_name == "room_castle_outskirts":
        return {"text": [
            "* Come to think of it,[wait:5] how did Lancer get up there...?",
            "* I suppose he rode his bike up the side of the cliff...?",
        ]}
    if room_name == "room_field_puzzle1":
        return {"text": "* Check the clock.[wait:5]\n* In order to solve this puzzle,[wait:5] you'll have to hurry."}
    if room_name == "room_field_shop1":
        return {"text": [
            "* (Store to the left.)\n* (Come on in and buy something...)",
            "* (Or don't.)",
        ]}
    if room_name == "room_field_puzzletutorial":
        return {"action": "donation_hole"}
    # This is the source object's deliberately unsettling default line.
    return {"text": "* Suddenly,[wait:5] your body seizes up.\n* What are you looking at?"}


def sign_text(room_name, x, y):
    if room_name == "room_field1" and x < 800:
        return "* (Enemies ahead![wait:5] You're gonna die!)\n* (SIGNED, LANCER)"
    if room_name == "room_field1":
        return "* (If you're reading this...[wait:5]\n  I guess you're dead.)\n* (SIGNED, LANCER)"
    if room_name == "room_field2":
        return "* (Hey,[wait:5] don't read this sign! It's a work in progress!)\n* (SIGNED, LANCER)"
    if room_name == "room_field2A":
        return [
            "* (These types of trees DON'T contain an item that can heal you.)",
            "* (Whatever you do,[wait:5] DON'T check the tree and open your menu!)",
            "* (You got it!?)\n* (SIGNED, LANCER)",
        ]
    if room_name == "room_field_maze":
        if y < 200:
            return "* (Behold,[wait:5] the Maze of Death!\n* Prepare to GET LOST,[wait:5] clowns!!!)\n* (SIGNED,[wait:5] LANCER)"
        if y < 640:
            return [
                "* (Feeling lost yet!? You must be UTTERLY HELPLESS among these twists and turns!)",
                "* (Your sense of direction won't save you now!)\n* (SIGNED, LANCER)",
            ]
        if y < 1000:
            return "* (Hey,[wait:5] wait!! Where am I!? Help! Somebody help! I'm lost!!)\n* (SIGNED,[wait:5] LANCER)"
        if x > 1000:
            return "* (Oh,[wait:5] it's just this way.)\n* (SIGNED,[wait:5] LANCER)"
        return "* (Hey,[wait:5] don't look! This sign's private!)\n* (SIGNED,[wait:5] LANCER)"
    if room_name == "room_field_puzzletutorial":
        return [
            '* "Hole Goals"',
            "$1 - Monthly tutorial,[wait:5] weekly.\n$10 - Weekly tutorial,[wait:5] monthly.\n$100 - Stop making tutorials.",
        ]
    return "* (The old sign is too weathered to read.)"


def door_connection(room_name, object_name):
    door = object_name.removeprefix("obj_door").replace("_musfade", "")
    if door == "X":
        target = {
            "room_castle_town": "room_castle_tutorial",
            "room_castle_tutorial": "room_castle_town",
        }.get(room_name)
        return (target, "marker_x") if target else None
    if door not in DOOR_STEPS:
        return None

    target_index = ROOM_INDEX[room_name] + DOOR_STEPS[door]
    if target_index < 0:
        return None
    if target_index >= len(ROOM_NAMES):
        return None
    return ROOM_NAMES[target_index], f"marker_{door.lower()}"


def converted_marker(room, x, y):
    # Chapter 1 stores the top-left of Kris's 19x38 sprite, drawn at 2x.
    # Kristal markers represent the character's bottom-center anchor.
    marker_x = x + 19
    marker_y = y + 76
    # Keep enough room for Kristal's follower chain; Chapter 1 originally
    # enters these rooms with only Kris, while this mod can spawn two members.
    marker_x = max(100, min(room["width"] - 100, marker_x))
    marker_y = max(100, min(room["height"] - 100, marker_y))
    return marker_x, marker_y


def entry_facing(target_name, marker_name):
    target = next((room for room in MANIFEST["rooms"] if room["name"] == target_name), None)
    if not target:
        return None
    suffix = marker_name.removeprefix("marker_").upper()
    marker = next((obj for obj in target["objects"] if obj["object"] == f"obj_marker{suffix}"), None)
    if not marker:
        return None
    distances = {
        "right": marker["x"],
        "left": target["width"] - marker["x"],
        "down": marker["y"],
        "up": target["height"] - marker["y"],
    }
    return min(distances, key=distances.get)


def lua_value(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value).lower()
    if isinstance(value, str):
        return json.dumps(value)
    if isinstance(value, list):
        return "{" + ", ".join(lua_value(item) for item in value) + "}"
    raise TypeError(value)


def object_lua(obj):
    props = obj.get("properties", {})
    props_text = ",\n".join(f'            ["{key}"] = {lua_value(value)}' for key, value in props.items())
    if props_text:
        props_text = "{\n" + props_text + "\n          }"
    else:
        props_text = "{}"
    return f'''        {{
          id = {obj["id"]},
          name = {lua_value(obj.get("name", ""))},
          type = "",
          shape = {lua_value(obj.get("shape", "rectangle"))},
          x = {obj["x"]},
          y = {obj["y"]},
          width = {obj.get("width", 0)},
          height = {obj.get("height", 0)},
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {props_text}
        }}'''


def group_lua(layer_id, name, objects):
    return f'''    {{
      type = "objectgroup",
      draworder = "topdown",
      id = {layer_id},
      name = "{name}",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {{}},
      objects = {{
{",\n".join(object_lua(obj) for obj in objects)}
      }}
    }}'''


def build_room(room):
    name = room["name"]
    next_id = 1

    def make(name_value, x, y, width=0, height=0, shape="rectangle", **properties):
        nonlocal next_id
        result = {
            "id": next_id,
            "name": name_value,
            "x": x,
            "y": y,
            "width": width,
            "height": height,
            "shape": shape,
            "properties": properties,
        }
        next_id += 1
        return result

    collisions = []
    enemy_collisions = []
    markers = []
    objects = [make(
        "ch1_room_art", 0, 0,
        texture=f"world/ch1_dark/rooms/{name}",
    )]

    main = next(obj for obj in room["objects"] if obj["object"] == "obj_mainchara")
    spawn_x, spawn_y = converted_marker(room, main["x"], main["y"])
    markers.append(make("event_spawn", spawn_x, spawn_y, shape="point"))
    if name == "room_dark1":
        markers.append(make("spawn", spawn_x, spawn_y, shape="point"))

    for source in room["objects"]:
        kind = source["object"]
        x, y = source["x"], source["y"]
        scale_x, scale_y = abs(float(source["scale_x"])), abs(float(source["scale_y"]))

        if kind == "obj_soliddark":
            collisions.append(make("", x, y, 40 * scale_x, 40 * scale_y))
        elif kind == "obj_solidenemy":
            enemy_collisions.append(make("", x, y, 40 * scale_x, 40 * scale_y))
        elif kind.startswith("obj_marker"):
            suffix = kind.removeprefix("obj_marker").lower()
            marker_x, marker_y = converted_marker(room, x, y)
            markers.append(make(f"marker_{suffix}", marker_x, marker_y, shape="point"))
        elif kind.startswith("obj_door"):
            connection = door_connection(name, kind)
            if connection:
                target, marker = connection
                facing = entry_facing(target, marker)
                transition_properties = {"map": target, "marker": marker}
                if facing:
                    transition_properties["facing"] = facing
                objects.append(make(
                    "transition", x, y, 20 * scale_x, 20 * scale_y,
                    **transition_properties,
                ))
        elif kind == "obj_savepoint":
            objects.append(make(
                "savepoint", x, y, 40, 40,
                text=[
                    "* At times,[wait:5] you see it flickering.\n* The light only you can see.",
                    "* By second nature,[wait:5] you reach out,[wait:5] and...",
                ],
            ))
        elif kind == "obj_npc_susiedark":
            objects.append(make("ch1_susie_npc", x, y, 52, 92))
        elif kind == "obj_chaseenemy":
            objects.append(make(
                "ch1_enemy", x, y, 70, 80,
                encounter="ch1_rudinn_duo" if name == "room_field2" else "ch1_rudinn",
                defeated_flag=f"ch1_enemy_{name}_{source['id']}",
            ))
        elif kind == "obj_darkeyepuzzle_switch":
            switch_index = 1 if x < 600 else (2 if x < 700 else 3)
            objects.append(make(
                "ch1_eye_switch", x, y, 40 * scale_x, 40 * scale_y,
                index=switch_index,
            ))
        elif kind == "obj_glowtilepuzz":
            tile_count = 3 if name == "room_field_puzzle1" else 6
            objects.append(make(
                "ch1_glow_controller", x, y, 40, 40,
                puzzle=name, tile_count=tile_count,
            ))
        elif kind == "obj_glowtile":
            objects.append(make(
                "ch1_glow_tile", x, y, 40, 40,
                puzzle=name, index=source["id"],
            ))
        elif kind == "obj_getsusieevent":
            objects.append(make("ch1_getsusie", x, y, 52, 92))
        elif kind == "obj_treasure_room":
            objects.append(make(
                "ch1_treasure", x, y, 40 * scale_x, 40 * scale_y,
                flag=f"ch1_treasure_{name}_{source['id']}",
            ))
        elif kind == "obj_pushableblock":
            objects.append(make(
                "ch1_pushblock", x, y, 40, 40,
                puzzle=name, block_id=source["id"],
            ))
        elif kind == "obj_blocktile":
            objects.append(make(
                "ch1_block_target", x, y, 40, 40,
                puzzle=name, target_id=source["id"],
            ))
        elif kind == "obj_boxpuzzle_event":
            objects.append(make("ch1_box_gate", x, y, 100, 120, puzzle=name))
        elif kind == "obj_scarelancerevent":
            objects.append(make(
                "ch1_prop", x, y, 80, 80,
                sprite="world/ch1_dark/extracted/spr_lancer_rt",
                frames=SPRITES["spr_lancer_rt"]["frames"], animation_speed=0.15,
                scale_x=2, scale_y=2, origin_x=0, origin_y=0,
                action="scare_lancer", solid=True,
            ))
        elif kind in {"obj_lancerchaseevent", "obj_lancerslideevent", "obj_darklanding", "obj_darkcastle_event", "obj_tutorialbattleevent"}:
            trigger = {
                "obj_lancerchaseevent": "lancer_chase",
                "obj_lancerslideevent": "lancer_slide",
                "obj_darklanding": "dark_landing",
                "obj_darkcastle_event": "castle_front",
                "obj_tutorialbattleevent": "tutorial",
            }[kind]
            objects.append(make(
                "ch1_trigger", x, y, max(40, 40 * scale_x), max(40, 40 * scale_y),
                trigger=trigger,
                flag="ch1_castle_prophecy_v4" if trigger == "castle_front" else f"ch1_trigger_{trigger}",
                auto=kind in {"obj_darkcastle_event", "obj_darklanding"},
            ))
            if kind == "obj_lancerchaseevent":
                objects.append(make("ch1_spade_chase", x, y, 40, 40))
        elif kind == "obj_wobblything":
            objects.append(make(
                "ch1_prop", x, y, 78, 74,
                sprite="world/ch1_dark/extracted/spr_wobblything",
                frames=4, animation_speed=0.17, trigger="near_x",
                sound="ch1_dark/wobbler", scale_x=2, scale_y=2,
                origin_x=10, origin_y=5,
            ))
        elif kind == "obj_darklancer":
            direction = "up" if name == "room_dark2" else "right"
            objects.append(make(
                "ch1_prop", x, y, 72, 68,
                sprite="world/ch1_dark/extracted/spr_darklancer",
                frames=2, animation_speed=0.17,
                trigger=f"lancer_{direction}", motion=direction,
                motion_speed=240, scale_x=2, scale_y=2,
            ))
        elif kind in {"obj_dustpile", "obj_dustpile_susie"}:
            objects.append(make("ch1_dustpile", x, y, 126, 92))
        elif kind == "obj_darkslide":
            objects.append(make("ch1_slide", x, y, 20 * scale_x, 20 * scale_y))
        elif kind == "obj_npc_room_animated" and name == "room_dark1":
            objects.append(make("ch1_shine", x, y, 40, 40))
        elif kind == "obj_readable_room1":
            width, height = 20 * scale_x, 20 * scale_y
            if name == "room_dark3a":
                objects.append(make("ch1_glowshard", x, y, width, height))
            else:
                objects.append(make("ch1_readable", x, y, width, height, **readable_properties(name)))
        elif kind == "obj_solidblock" and source.get("sprite") in SPRITES:
            sprite = SPRITES[source["sprite"]]
            collisions.append(make("", x, y, sprite["width"] * scale_x, sprite["height"] * scale_y))
        elif kind == "obj_purplegrass":
            objects.append(make(
                "ch1_grass", x, y, 40 * scale_x, 40 * scale_y,
                columns=scale_x, rows=scale_y, frames=9,
            ))
        elif kind in GENERIC_VISUALS and source.get("sprite") in SPRITES:
            sprite_name = source["sprite"]
            if kind == "obj_npc_room" and name == "room_castle_tutorial":
                sprite_name = "spr_dummynpc"
            elif kind == "obj_npc_room" and name == "room_field2A":
                sprite_name = "spr_candytree"
            elif kind == "obj_npc_facing" and name == "room_field2":
                sprite_name = "spr_lancer_dt"

            sprite = SPRITES.get(sprite_name)
            if sprite:
                final_scale_x = scale_x
                final_scale_y = scale_y
                if kind in {"obj_chaseenemy", "obj_npc_room", "obj_npc_facing", "obj_npc_sign", "obj_wobblything_evil"}:
                    final_scale_x = max(2, final_scale_x)
                    final_scale_y = max(2, final_scale_y)
                frame = 0
                extra = {}
                if kind == "obj_castle_house":
                    frame = (2 if y >= 560 else 0) + (1 if x >= room["width"] / 2 else 0)
                elif kind == "obj_npc_sign":
                    extra["solid"] = True
                    extra["text"] = sign_text(name, x, y)
                elif kind == "obj_npc_facing" and name == "room_field2":
                    extra["solid"] = True
                    extra["action"] = "field2_lancer"
                elif kind == "obj_npc_room" and name == "room_field2A":
                    extra["solid"] = True
                    extra["action"] = "candy_tree"
                elif kind in {"obj_npc_room", "obj_npc_room_animated", "obj_npc_puzzlemaster1", "obj_npc_puzzlemaster2", "obj_hathyfightevent"}:
                    extra["solid"] = True
                    extra["text"] = "* The Darkner looks at you expectantly."
                elif kind == "obj_shortcut_door":
                    extra["solid"] = True
                    extra["text"] = "* (The shortcut door is locked from the other side.)"
                objects.append(make(
                    "ch1_prop", x, y,
                    sprite["width"] * final_scale_x,
                    sprite["height"] * final_scale_y,
                    sprite=f"world/ch1_dark/extracted/{sprite_name}",
                    frames=sprite["frames"],
                    start_frame=min(frame, max(0, sprite["frames"] - 1)),
                    animation_speed=0.17 if kind in {"obj_castle_torch", "obj_chaseenemy", "obj_wobblything_evil"} else 0,
                    scale_x=final_scale_x, scale_y=final_scale_y,
                    origin_x=sprite["origin_x"],
                    origin_y=sprite["origin_y"],
                    **extra,
                ))

    if name == "room_dark_eyepuzzle":
        objects.append(make("ch1_eye_gate", 960, 320, 60, 80))
    elif name == "room_field_puzzle1":
        objects.append(make("ch1_glow_gate", 1280, 280, 120, 80, puzzle=name))

    if name == "room_dark_chase2":
        objects.append(make(
            "transition", 0, room["height"] - 80, room["width"], 80,
            map="room_castle_outskirts", marker="event_spawn",
        ))
    elif name == "room_castle_darkdoor":
        objects.append(make(
            "transition", 384, 150, 90, 60,
            map="room_field_start", marker="event_spawn",
        ))
    elif name == "room_field_getsusie":
        objects.append(make(
            "transition", 400, 100, 120, 60,
            map="room_field_shop1", marker="marker_a", facing="down",
        ))

    properties = {
        "name": f"Chapter 1 - {name}",
        "border": "simple",
    }
    if name in {"room_dark2", "room_dark_eyepuzzle"}:
        properties["music"] = "creepylandscape"
    elif name == "room_castle_town":
        properties["music"] = "castletown_empty"
    elif name in {"room_field_start", "room_field_forest"}:
        properties["music"] = "bird"
    elif name == "room_field1":
        properties["music"] = "field_of_hopes"
    elif name not in {"room_dark1", "room_dark1a"}:
        properties["keepmusic"] = True

    properties_text = ",\n".join(f'    ["{key}"] = {lua_value(value)}' for key, value in properties.items())
    ground_names = {"ch1_room_art", "ch1_grass", "ch1_block_target"}
    ground_objects = [obj for obj in objects if obj["name"] in ground_names]
    active_objects = [obj for obj in objects if obj["name"] not in ground_names]
    layers = [
        group_lua(1, "collision", collisions),
        group_lua(2, "objects_ground", ground_objects),
        group_lua(3, "markers", markers),
        group_lua(4, "enemycollision", enemy_collisions),
        group_lua(5, "objects_party", []),
        group_lua(6, "objects", active_objects),
    ]
    text = f'''return {{
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = {math.ceil(room["width"] / 40)},
  height = {math.ceil(room["height"] / 40)},
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = {next_id},
  properties = {{
{properties_text}
  }},
  tilesets = {{}},
  layers = {{
{",\n".join(layers)}
  }}
}}
'''
    (MAP_OUT / f"{name}.lua").write_text(text, encoding="utf-8")


def main():
    for room in MANIFEST["rooms"]:
        build_room(room)
    print(f"Built {len(MANIFEST['rooms'])} Kristal maps.")


if __name__ == "__main__":
    main()
