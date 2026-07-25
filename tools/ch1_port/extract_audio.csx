using System;
using System.IO;
using System.Collections.Generic;
using UndertaleModLib.Models;

var root = @"C:\Users\Cesuss\AppData\Roaming\kristal\mods\son";
var output = Path.Combine(root, "assets", "sounds", "ch1_dark");
Directory.CreateDirectory(output);
var wanted = new HashSet<string>(new[] { "snd_noise", "snd_cough", "snd_wobbler", "snd_save" });
var groups = new Dictionary<int, IList<UndertaleEmbeddedAudio>>();

IList<UndertaleEmbeddedAudio> LoadGroup(int id)
{
    if (groups.TryGetValue(id, out var cached))
        return cached;
    var path = Path.Combine(Path.GetDirectoryName(FilePath), $"audiogroup{id}.dat");
    using var stream = new FileStream(path, FileMode.Open, FileAccess.Read);
    var group = UndertaleIO.Read(stream).EmbeddedAudio;
    groups[id] = group;
    return group;
}

foreach (var sound in Data.Sounds)
{
    if (!wanted.Contains(sound.Name.Content))
        continue;
    byte[] bytes = sound.AudioFile?.Data;
    if (bytes == null && sound.GroupID > Data.GetBuiltinSoundGroupID())
        bytes = LoadGroup(sound.GroupID)[sound.AudioID].Data;
    if (bytes == null)
        continue;
    var name = sound.Name.Content.Substring(4) + ".wav";
    File.WriteAllBytes(Path.Combine(output, name), bytes);
    Console.WriteLine($"Exported {name}");
}
