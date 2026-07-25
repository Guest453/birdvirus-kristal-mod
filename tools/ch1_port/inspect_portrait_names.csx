using System;
using System.Linq;

foreach (var sprite in Data.Sprites)
{
    var name = sprite.Name.Content;
    var lower = name.ToLowerInvariant();
    if (lower.Contains("face") || lower.Contains("portrait") || lower.Contains("ralface") ||
        lower.StartsWith("spr_ral") || lower.StartsWith("spr_susface") || lower.StartsWith("spr_lanface"))
        Console.WriteLine(name);
}
