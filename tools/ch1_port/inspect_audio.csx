using System;

foreach (var sound in Data.Sounds)
{
    var name = sound.Name.Content;
    var file = sound.File?.Content ?? "";
    if (name.IndexOf("wobbl", StringComparison.OrdinalIgnoreCase) >= 0 ||
        name.IndexOf("cough", StringComparison.OrdinalIgnoreCase) >= 0 ||
        name.IndexOf("noise", StringComparison.OrdinalIgnoreCase) >= 0 ||
        name.IndexOf("save", StringComparison.OrdinalIgnoreCase) >= 0 ||
        file.IndexOf("creepy", StringComparison.OrdinalIgnoreCase) >= 0 ||
        name.IndexOf("chase", StringComparison.OrdinalIgnoreCase) >= 0 ||
        file.IndexOf("chase", StringComparison.OrdinalIgnoreCase) >= 0)
        Console.WriteLine($"{name}\t{file}\t{sound.Flags}\tgroup={sound.GroupID}\taudio={sound.AudioID}");
}
