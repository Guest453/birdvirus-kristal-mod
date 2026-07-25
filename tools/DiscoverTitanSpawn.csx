using System;
using System.IO;
using System.Collections.Generic;
using UndertaleModLib.Util;

EnsureDataLoaded();

string output = @"C:\Users\Cesus\AppData\Roaming\LOVE\kristal\mods\son\extracted\titan_spawn_chapter4\discovery.txt";
Directory.CreateDirectory(Path.GetDirectoryName(output));
List<string> lines = new();
lines.Add("Read-only discovery from: " + FilePath);
lines.Add("Generated: " + DateTime.Now.ToString("O"));

bool Match(string value)
{
    if (value is null) return false;
    string normalized = value.Replace("_", " ").Replace("-", " ").ToLowerInvariant();
    return normalized.Contains("titan spawn") || normalized.Contains("titanspawn");
}

void AddNamed<T>(string kind, IEnumerable<T> resources, Func<T, string> getName)
{
    foreach (T resource in resources)
    {
        string name = getName(resource);
        if (Match(name)) lines.Add(kind + " " + name);
    }
}

AddNamed("OBJECT", Data.GameObjects, x => x?.Name?.Content);
AddNamed("SPRITE", Data.Sprites, x => x?.Name?.Content);
AddNamed("SOUND", Data.Sounds, x => x?.Name?.Content);
AddNamed("SCRIPT", Data.Scripts, x => x?.Name?.Content);
AddNamed("CODE_NAME", Data.Code, x => x?.Name?.Content);
AddNamed("ROOM", Data.Rooms, x => x?.Name?.Content);

lines.Add("");
lines.Add("DECOMPILED REFERENCES");
GlobalDecompileContext globalContext = new(Data);
var settings = Data.ToolInfo.DecompilerSettings;
foreach (UndertaleCode code in Data.Code)
{
    if (code is null || code.ParentEntry != null) continue;
    try
    {
        string text = new Underanalyzer.Decompiler.DecompileContext(globalContext, code, settings).DecompileToString();
        if (Match(text))
        {
            lines.Add("--- " + code.Name.Content + " ---");
            lines.Add(text);
        }
    }
    catch (Exception exception)
    {
        if (Match(code.Name.Content)) lines.Add("DECOMPILE_FAILED " + code.Name.Content + ": " + exception.Message);
    }
}

File.WriteAllLines(output, lines);
File.WriteAllText(Path.Combine(Path.GetDirectoryName(output), "DISCOVERY_COMPLETE.txt"), DateTime.Now.ToString("O"));
