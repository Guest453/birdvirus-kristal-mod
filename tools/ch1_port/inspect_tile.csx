using System;
using System.Collections;
using System.Linq;
using UndertaleModLib.Models;

var room = Data.Rooms.First(r => r.Name.Content == "room_dark1");
var layer = room.Layers.First(l => l.Data is UndertaleRoom.Layer.LayerAssetsData a && a.LegacyTiles.Count > 0);
var assets = (UndertaleRoom.Layer.LayerAssetsData)layer.Data;
var tile = assets.LegacyTiles[0];
Console.WriteLine(tile.GetType().FullName);
foreach (var prop in tile.GetType().GetProperties())
{
    object value = null;
    try { value = prop.GetValue(tile); } catch { }
    Console.WriteLine($"{prop.Name}\t{prop.PropertyType.FullName}\t{value}");
}
