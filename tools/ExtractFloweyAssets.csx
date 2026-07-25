using System;
using System.IO;
using System.Collections.Generic;
using UndertaleModLib.Util;

EnsureDataLoaded();

string outputRoot = @"C:\Users\Cesus\AppData\Roaming\LOVE\kristal\mods\son\extracted\flowey_chapter5";
string spriteRoot = Path.Combine(outputRoot, "sprites");
string soundRoot = Path.Combine(outputRoot, "sounds");
Directory.CreateDirectory(spriteRoot);
Directory.CreateDirectory(soundRoot);

List<string> manifest = new();
manifest.Add("Flowey asset extraction from: " + FilePath);
manifest.Add("Generated: " + DateTime.Now.ToString("O"));
manifest.Add("");

bool MatchesFlowey(string name)
{
    return name.Contains("flowey", StringComparison.OrdinalIgnoreCase)
        || name.Contains("flowery", StringComparison.OrdinalIgnoreCase);
}

int spriteCount = 0;
int spriteFrameCount = 0;
using (TextureWorker worker = new())
{
    foreach (UndertaleSprite sprite in Data.Sprites)
    {
        if (sprite?.Name?.Content is not string spriteName || !MatchesFlowey(spriteName))
            continue;

        string spriteFolder = Path.Combine(spriteRoot, spriteName);
        Directory.CreateDirectory(spriteFolder);
        int exportedFrames = 0;

        for (int frame = 0; frame < sprite.Textures.Count; frame++)
        {
            UndertaleTexturePageItem pageItem = sprite.Textures[frame]?.Texture;
            if (pageItem is null)
                continue;

            string destination = Path.Combine(spriteFolder, $"{spriteName}_{frame}.png");
            worker.ExportAsPNG(pageItem, destination, null, true);
            exportedFrames++;
            spriteFrameCount++;
        }

        spriteCount++;
        manifest.Add($"SPRITE {spriteName} ({exportedFrames} frame(s))");
    }
}

byte[] emptyWav = Convert.FromBase64String("UklGRiQAAABXQVZFZm10IBAAAAABAAIAQB8AAAB9AAAEABAAZGF0YQAAAAA=");
Dictionary<string, IList<UndertaleEmbeddedAudio>> loadedAudioGroups = new();

IList<UndertaleEmbeddedAudio> GetAudioGroupData(UndertaleSound sound)
{
    string groupName = sound.AudioGroup?.Name?.Content ?? "audiogroup_default";
    if (loadedAudioGroups.TryGetValue(groupName, out IList<UndertaleEmbeddedAudio> cached))
        return cached;

    string relativePath = sound.AudioGroup is UndertaleAudioGroup { Path.Content: string customPath }
        ? customPath
        : $"audiogroup{sound.GroupID}.dat";
    string groupPath = Path.Combine(Path.GetDirectoryName(FilePath), relativePath);
    if (!File.Exists(groupPath))
        return null;

    try
    {
        UndertaleData groupData;
        using (FileStream stream = new(groupPath, FileMode.Open, FileAccess.Read))
            groupData = UndertaleIO.Read(stream, (warning, _) => { });
        loadedAudioGroups[groupName] = groupData.EmbeddedAudio;
        return groupData.EmbeddedAudio;
    }
    catch (Exception exception)
    {
        manifest.Add($"WARNING could not load audio group {groupName}: {exception.Message}");
        return null;
    }
}

byte[] GetSoundData(UndertaleSound sound)
{
    if (sound.AudioFile is not null)
        return sound.AudioFile.Data;

    if (sound.GroupID > Data.GetBuiltinSoundGroupID())
    {
        IList<UndertaleEmbeddedAudio> group = GetAudioGroupData(sound);
        if (group is not null && sound.AudioID >= 0 && sound.AudioID < group.Count)
            return group[sound.AudioID].Data;
    }

    return emptyWav;
}

int soundCount = 0;
foreach (UndertaleSound sound in Data.Sounds)
{
    if (sound?.Name?.Content is not string soundName || !MatchesFlowey(soundName))
        continue;

    bool compressed = sound.Flags.HasFlag(UndertaleSound.AudioEntryFlags.IsCompressed);
    bool embedded = sound.Flags.HasFlag(UndertaleSound.AudioEntryFlags.IsEmbedded);
    string extension = embedded && !compressed ? ".wav" : ".ogg";
    string destination = Path.Combine(soundRoot, soundName + extension);

    if (!compressed && !embedded)
    {
        string externalName = sound.File?.Content ?? soundName + ".ogg";
        if (!Path.HasExtension(externalName))
            externalName += ".ogg";
        string source = Path.Combine(Path.GetDirectoryName(FilePath), externalName);
        if (File.Exists(source))
        {
            extension = Path.GetExtension(source);
            destination = Path.Combine(soundRoot, soundName + extension);
            File.Copy(source, destination, true);
        }
        else
        {
            manifest.Add($"WARNING external sound missing: {soundName} -> {source}");
            continue;
        }
    }
    else
    {
        File.WriteAllBytes(destination, GetSoundData(sound));
    }

    soundCount++;
    manifest.Add($"SOUND {soundName} -> {Path.GetFileName(destination)}");
}

manifest.Add("");
manifest.Add($"TOTAL sprites: {spriteCount}");
manifest.Add($"TOTAL sprite frames: {spriteFrameCount}");
manifest.Add($"TOTAL sounds: {soundCount}");
File.WriteAllLines(Path.Combine(outputRoot, "manifest.txt"), manifest);
File.WriteAllText(Path.Combine(outputRoot, "EXTRACTION_COMPLETE.txt"), DateTime.Now.ToString("O"));
