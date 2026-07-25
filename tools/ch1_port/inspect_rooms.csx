using System;
using System.Collections.Generic;

var wanted = new HashSet<string>(new[] {
    "room_dark1", "room_dark1a", "room_dark2", "room_dark3", "room_dark3a",
    "room_dark_wobbles", "room_dark_eyepuzzle", "room_dark7", "room_dark_chase1", "room_dark_chase2",
    "room_castle_outskirts", "room_castle_town", "room_castle_front", "room_castle_tutorial",
    "room_castle_darkdoor", "room_field_start", "room_field_forest", "room_field1", "room_field2", "room_field2A"
});

foreach (var room in Data.Rooms)
{
    if (!wanted.Contains(room.Name.Content))
        continue;

    Console.WriteLine($"ROOM\t{room.Name.Content}\t{room.Width}\t{room.Height}\t{room.Speed}\tobjs={room.GameObjects.Count}\ttiles={room.Tiles.Count}\tbgs={room.Backgrounds.Count}");
    foreach (var obj in room.GameObjects)
    {
        Console.WriteLine($"OBJ\t{obj.InstanceID}\t{obj.ObjectDefinition.Name.Content}\t{obj.X}\t{obj.Y}\t{obj.ScaleX}\t{obj.ScaleY}\t{obj.Rotation}\t{(obj.CreationCode == null ? "-" : obj.CreationCode.Name.Content)}");
    }

    foreach (var bg in room.Backgrounds)
    {
        if (!bg.Enabled)
            continue;
        Console.WriteLine($"BG\t{(bg.BackgroundDefinition == null ? "-" : bg.BackgroundDefinition.Name.Content)}\t{bg.X}\t{bg.Y}\t{bg.SpeedX}\t{bg.SpeedY}\t{bg.Stretch}\t{bg.TiledHorizontally}\t{bg.TiledVertically}\t{bg.Foreground}");
    }

    foreach (var layer in room.Layers)
    {
        Console.WriteLine($"LAYER\t{layer.LayerName.Content}\t{layer.LayerType}\tdepth={layer.LayerDepth}\tdata={layer.Data?.GetType().Name}");
        if (layer.Data == null)
            continue;
        foreach (var prop in layer.Data.GetType().GetProperties())
        {
            object value;
            try { value = prop.GetValue(layer.Data); }
            catch { continue; }
            if (value == null)
                continue;
            if (value is System.Collections.ICollection collection)
                Console.WriteLine($"  PROP\t{prop.Name}\t{value.GetType().Name}\tcount={collection.Count}");
            else
                Console.WriteLine($"  PROP\t{prop.Name}\t{value}");
        }
    }

    Console.WriteLine($"CREATION\t{(room.CreationCodeId == null ? "-" : room.CreationCodeId.Name.Content)}");
}

Console.WriteLine("RALSEI_SPRITES");
foreach (var sprite in Data.Sprites)
{
    var name = sprite.Name.Content;
    if (name.IndexOf("ralsei", StringComparison.OrdinalIgnoreCase) >= 0)
        Console.WriteLine($"SPR\t{name}\t{sprite.Width}\t{sprite.Height}\tframes={sprite.Textures.Count}\torigin={sprite.OriginX},{sprite.OriginY}");
}
