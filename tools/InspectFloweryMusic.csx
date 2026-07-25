using System;
using System.IO;
using System.Collections.Generic;

EnsureDataLoaded();

string output = @"C:\Users\Cesus\AppData\Roaming\LOVE\kristal\mods\son\extracted\flowey_chapter5\music_resources.txt";
List<string> lines = new();

foreach (UndertaleSound sound in Data.Sounds)
{
    string name = sound?.Name?.Content ?? "";
    string file = sound?.File?.Content ?? "";
    if (name.Contains("flow", StringComparison.OrdinalIgnoreCase)
        || file.Contains("flow", StringComparison.OrdinalIgnoreCase))
    {
        lines.Add($"{name} | file={file} | group={sound.GroupID} | audio={sound.AudioID} | flags={sound.Flags}");
    }
}

File.WriteAllLines(output, lines);
