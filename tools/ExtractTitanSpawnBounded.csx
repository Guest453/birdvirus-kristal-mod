using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using UndertaleModLib.Util;

EnsureDataLoaded();

string root = @"C:\Users\Cesus\AppData\Roaming\LOVE\kristal\mods\son\extracted\titan_spawn_chapter4\bounded";
Directory.CreateDirectory(root);
string[] exactObjects = {
    "obj_titan_spawn_enemy", "obj_darkshape", "obj_redshape", "obj_darkshape_manager",
    "obj_darkshape_light_aura", "obj_darkshape_greenblob", "obj_dbulletcontroller"
};
string[] needles = {
    "obj_titan_spawn_enemy", "pattern_default_intro", "pattern_default_speedup",
    "obj_darkshape_light_aura", "obj_darkshape_greenblob", "obj_redshape",
    "darkness", "BANISH", "BRIGHTEN"
};

GlobalDecompileContext global = new(Data);
var settings = Data.ToolInfo.DecompilerSettings;
int written = 0;
foreach (UndertaleCode code in Data.Code)
{
    if (code is null || code.ParentEntry != null) continue;
    string name = code.Name.Content;
    bool named = exactObjects.Any(o => name.Contains("Object_" + o + "_", StringComparison.OrdinalIgnoreCase));
    bool likelyGlobal = name.StartsWith("gml_GlobalScript_", StringComparison.OrdinalIgnoreCase);
    if (!named && !likelyGlobal) continue;
    try
    {
        string text = new Underanalyzer.Decompiler.DecompileContext(global, code, settings).DecompileToString();
        if (!named && !needles.Any(n => text.Contains(n, StringComparison.OrdinalIgnoreCase))) continue;
        File.WriteAllText(Path.Combine(root, name + ".gml"), text);
        written++;
    }
    catch (Exception e) { File.AppendAllText(Path.Combine(root, "errors.txt"), name + ": " + e.Message + Environment.NewLine); }
}

string spriteRoot = Path.Combine(root, "sprites");
Directory.CreateDirectory(spriteRoot);
string[] spriteNeedles = { "darkshape", "redshape", "heart_shine", "light_aura", "greenblob" };
using (TextureWorker worker = new())
foreach (UndertaleSprite sprite in Data.Sprites)
{
    string name = sprite?.Name?.Content ?? "";
    if (!spriteNeedles.Any(n => name.Contains(n, StringComparison.OrdinalIgnoreCase))) continue;
    string folder = Path.Combine(spriteRoot, name);
    Directory.CreateDirectory(folder);
    for (int i = 0; i < sprite.Textures.Count; i++)
    {
        UndertaleTexturePageItem item = sprite.Textures[i]?.Texture;
        if (item != null) worker.ExportAsPNG(item, Path.Combine(folder, $"{name}_{i}.png"), null, true);
    }
}
File.WriteAllText(Path.Combine(root, "manifest.txt"), $"Read-only bounded extraction from {FilePath}{Environment.NewLine}Code entries: {written}{Environment.NewLine}");
