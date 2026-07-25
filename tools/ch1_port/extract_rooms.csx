#r "Newtonsoft.Json.dll"

using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using Newtonsoft.Json;
using UndertaleModLib.Models;
using UndertaleModLib.Util;

var root = @"C:\Users\Cesuss\AppData\Roaming\kristal\mods\son";
var rawRoot = Path.Combine(root, "tools", "ch1_port", "raw");
var tilesetRoot = Path.Combine(rawRoot, "tilesets");
var spriteRoot = Path.Combine(rawRoot, "sprites");
Directory.CreateDirectory(tilesetRoot);
Directory.CreateDirectory(spriteRoot);

var wanted = new HashSet<string>(new[] {
    "room_dark1", "room_dark1a", "room_dark2", "room_dark3", "room_dark3a",
    "room_dark_wobbles", "room_dark_eyepuzzle", "room_dark7", "room_dark_chase1", "room_dark_chase2",
    "room_castle_outskirts", "room_castle_town", "room_castle_front", "room_castle_tutorial",
    "room_castle_darkdoor", "room_field_start", "room_field_forest", "room_field1", "room_field2", "room_field2A"
    , "room_field_topchef", "room_field_puzzle1", "room_field_maze", "room_field_puzzle2"
    , "room_field_getsusie", "room_field_shop1", "room_field_puzzletutorial", "room_field3"
    , "room_field_boxpuzzle", "room_field4"
});
var roomsOut = new List<Dictionary<string, object>>();
var backgrounds = new Dictionary<string, UndertaleBackground>();
var sprites = new Dictionary<string, UndertaleSprite>();

foreach (var room in Data.Rooms.Where(r => wanted.Contains(r.Name.Content)))
{
    var roomOut = new Dictionary<string, object> {
        ["name"] = room.Name.Content,
        ["width"] = room.Width,
        ["height"] = room.Height
    };
    var layersOut = new List<Dictionary<string, object>>();

    foreach (var layer in room.Layers.OrderByDescending(l => l.LayerDepth))
    {
        if (layer.Data is UndertaleRoom.Layer.LayerBackgroundData background)
        {
            var sprite = background.Sprite;
            if (!background.Visible || sprite == null)
                continue;

            var spriteName = sprite.Name.Content;
            sprites[spriteName] = sprite;
            layersOut.Add(new Dictionary<string, object> {
                ["name"] = layer.LayerName.Content,
                ["depth"] = layer.LayerDepth,
                ["kind"] = "background",
                ["sprite"] = spriteName,
                ["x"] = background.XOffset,
                ["y"] = background.YOffset,
                ["tiled_x"] = background.TiledHorizontally,
                ["tiled_y"] = background.TiledVertically,
                ["stretch"] = background.Stretch
            });
            continue;
        }

        if (layer.Data is not UndertaleRoom.Layer.LayerAssetsData assets || assets.LegacyTiles.Count == 0)
            continue;

        var tilesOut = new List<Dictionary<string, object>>();
        foreach (var tile in assets.LegacyTiles)
        {
            string assetType = null;
            string assetName = null;
            if (tile.BackgroundDefinition != null)
            {
                assetType = "background";
                assetName = tile.BackgroundDefinition.Name.Content;
                backgrounds[assetName] = tile.BackgroundDefinition;
            }
            else if (tile.SpriteDefinition != null)
            {
                assetType = "sprite";
                assetName = tile.SpriteDefinition.Name.Content;
                sprites[assetName] = tile.SpriteDefinition;
            }
            if (assetName == null)
                continue;

            tilesOut.Add(new Dictionary<string, object> {
                ["asset_type"] = assetType,
                ["asset"] = assetName,
                ["x"] = tile.X,
                ["y"] = tile.Y,
                ["source_x"] = tile.SourceX,
                ["source_y"] = tile.SourceY,
                ["width"] = tile.Width,
                ["height"] = tile.Height,
                ["scale_x"] = tile.ScaleX,
                ["scale_y"] = tile.ScaleY,
                ["depth"] = tile.TileDepth
            });
        }
        layersOut.Add(new Dictionary<string, object> {
            ["name"] = layer.LayerName.Content,
            ["depth"] = layer.LayerDepth,
            ["kind"] = "tiles",
            ["tiles"] = tilesOut
        });
    }
    roomOut["layers"] = layersOut;

    var objectsOut = new List<Dictionary<string, object>>();
    foreach (var obj in room.GameObjects)
    {
        var sprite = obj.ObjectDefinition?.Sprite;
        string spriteName = sprite?.Name.Content;
        if (sprite != null)
            sprites[spriteName] = sprite;
        objectsOut.Add(new Dictionary<string, object> {
            ["id"] = obj.InstanceID,
            ["object"] = obj.ObjectDefinition?.Name.Content,
            ["sprite"] = spriteName,
            ["x"] = obj.X,
            ["y"] = obj.Y,
            ["scale_x"] = obj.ScaleX,
            ["scale_y"] = obj.ScaleY,
            ["rotation"] = obj.Rotation
        });
    }
    roomOut["objects"] = objectsOut;
    roomsOut.Add(roomOut);
}

var extraSpriteNames = new HashSet<string>(new[] {
    "spr_kris_fell", "spr_kris_fallen_dark", "spr_krisd_slide", "spr_slidedust",
    "spr_dustpile_parts", "spr_dustball", "spr_susier_shadow", "spr_susie_shock",
    "spr_susiel_dark", "spr_susier_dark", "spr_susieu_dark", "spr_shine"
    , "spr_dummynpc", "spr_candytree", "spr_lancer_dt", "spr_lancer_rt", "spr_lancer_lt"
    , "spr_magicalglass", "spr_fieldmuslogo"
    , "spr_diamondm_idle", "spr_diamondm_hurt", "spr_diamondm_spared", "spr_diamondbullet"
    , "spr_spadebullet"
    , "spr_face_r_dark", "spr_face_l0", "spr_face_s0", "spr_face_s1", "spr_face_s2"
    , "spr_face_s3", "spr_face_s4", "spr_face_s5", "spr_face_s6", "spr_face_s7"
    , "spr_face_s8", "spr_face_s9", "spr_face_sA"
});
foreach (var sprite in Data.Sprites)
{
    var name = sprite.Name.Content;
    if (name.IndexOf("ralsei", StringComparison.OrdinalIgnoreCase) >= 0 || extraSpriteNames.Contains(name))
        sprites[name] = sprite;
}

using (var worker = new TextureWorker())
{
    foreach (var pair in backgrounds)
    {
        if (pair.Value?.Texture != null)
            worker.ExportAsPNG(pair.Value.Texture, Path.Combine(tilesetRoot, pair.Key + ".png"));
    }
    foreach (var pair in sprites)
    {
        var sprite = pair.Value;
        var dir = Path.Combine(spriteRoot, pair.Key);
        Directory.CreateDirectory(dir);
        for (var i = 0; i < sprite.Textures.Count; i++)
        {
            var texture = sprite.Textures[i]?.Texture;
            if (texture != null)
                worker.ExportAsPNG(texture, Path.Combine(dir, i + ".png"), null, true);
        }
    }
}

var spriteMeta = sprites.Values.Select(sprite => new Dictionary<string, object> {
    ["name"] = sprite.Name.Content,
    ["width"] = sprite.Width,
    ["height"] = sprite.Height,
    ["origin_x"] = sprite.OriginX,
    ["origin_y"] = sprite.OriginY,
    ["frames"] = sprite.Textures.Count
}).ToList();

var output = new Dictionary<string, object> {
    ["rooms"] = roomsOut,
    ["sprites"] = spriteMeta
};
File.WriteAllText(Path.Combine(root, "tools", "ch1_port", "ch1_rooms.json"), JsonConvert.SerializeObject(output, Formatting.Indented));
Console.WriteLine($"Exported {roomsOut.Count} rooms, {backgrounds.Count} tilesets, and {sprites.Count} sprites.");
