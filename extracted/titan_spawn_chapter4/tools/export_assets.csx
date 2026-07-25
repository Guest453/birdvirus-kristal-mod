using System.IO;
using System.Linq;
using UndertaleModLib.Util;

EnsureDataLoaded();
var root = @"C:\Users\Cesus\AppData\Roaming\LOVE\kristal\mods\son";
var audit = Path.Combine(root, "extracted", "titan_spawn_chapter4", "sprites");
var runtime = Path.Combine(root, "assets", "sprites", "enemies", "titan_spawn");
var bulletRuntime = Path.Combine(root, "assets", "sprites", "bullets", "titan_spawn");
Directory.CreateDirectory(audit);
Directory.CreateDirectory(runtime);
Directory.CreateDirectory(bulletRuntime);

var names = new[] { "spr_titan_spawn_idle", "spr_titan_spawn_hurt", "spr_darkshape_animated", "spr_darkshape" };
using (var worker = new TextureWorker())
foreach (var name in names)
{
    var sprite = Data.Sprites.ByName(name);
    if (sprite is null) { ScriptError("Missing sprite " + name); continue; }
    var auditDir = Path.Combine(audit, name);
    Directory.CreateDirectory(auditDir);
    var destination = name.StartsWith("spr_titan_spawn") ? runtime : bulletRuntime;
    for (var i = 0; i < sprite.Textures.Count; i++)
    {
        var texture = sprite.Textures[i]?.Texture;
        if (texture is null) continue;
        var filename = name + "_" + i + ".png";
        worker.ExportAsPNG(texture, Path.Combine(auditDir, filename), null, true);
        worker.ExportAsPNG(texture, Path.Combine(destination, filename), null, true);
    }
    ScriptMessage($"SPRITE_MAP {name}: frames={sprite.Textures.Count}, size={sprite.Width}x{sprite.Height}, origin={sprite.OriginX},{sprite.OriginY}");
}

var soundRuntime = Path.Combine(root, "assets", "sounds");
var musicRuntime = Path.Combine(root, "assets", "music");
Directory.CreateDirectory(soundRuntime);
Directory.CreateDirectory(musicRuntime);

foreach (var name in new[] { "snd_spawn_attack", "snd_dark_odd", "snd_organ_enemy_loop_temp", "snd_spawn_weaker", "snd_swallow", "snd_eye_telegraph", "snd_great_shine" })
{
    var sound = Data.Sounds.ByName(name);
    if (sound is null) { ScriptError("Missing sound " + name); continue; }
    ScriptMessage($"SOUND_MAP {name}: file={sound.File?.Content}, group={sound.AudioGroup?.Name?.Content}, id={sound.AudioID}, flags={sound.Flags}");
    if (sound.AudioFile?.Data is byte[] bytes)
    {
        var extension = Path.GetExtension(sound.File?.Content ?? ".ogg");
        File.WriteAllBytes(Path.Combine(soundRuntime, name + extension), bytes);
    }
}

var music = Data.Sounds.FirstOrDefault(x => x.File?.Content == "titan_spawn.ogg");
if (music?.AudioFile?.Data is byte[] musicBytes)
{
    File.WriteAllBytes(Path.Combine(musicRuntime, "titan_spawn.ogg"), musicBytes);
    ScriptMessage($"MUSIC_MAP {music.Name.Content}: file={music.File.Content}, group={music.AudioGroup?.Name?.Content}, id={music.AudioID}");
}
else ScriptError("Missing embedded music titan_spawn.ogg");
