// Read-only UTMT discovery script. Prints resources whose names identify Titan Spawn.
foreach (var x in Data.GameObjects)
    if (x.Name.Content.ToLowerInvariant().Contains("titan")) ScriptMessage("OBJECT " + x.Name.Content);
foreach (var x in Data.Sprites)
    if (x.Name.Content.ToLowerInvariant().Contains("titan")) ScriptMessage("SPRITE " + x.Name.Content);
foreach (var x in Data.Sounds)
    if (x.Name.Content.ToLowerInvariant().Contains("titan")) ScriptMessage("SOUND " + x.Name.Content);
foreach (var x in Data.Rooms)
    if (x.Name.Content.ToLowerInvariant().Contains("titan")) ScriptMessage("ROOM " + x.Name.Content);
foreach (var x in Data.Code)
    if (x.Name.Content.ToLowerInvariant().Contains("titan")) ScriptMessage("CODE " + x.Name.Content);
foreach (var x in Data.GameObjects)
    if (x.Name.Content.ToLowerInvariant().Contains("darkshape")) ScriptMessage("DARKSHAPE_OBJECT " + x.Name.Content);
foreach (var x in Data.Sprites)
    if (x.Name.Content.ToLowerInvariant().Contains("darkshape")) ScriptMessage("DARKSHAPE_SPRITE " + x.Name.Content);
foreach (var x in Data.Sounds)
    if (x.Name.Content.ToLowerInvariant().Contains("darkshape")) ScriptMessage("DARKSHAPE_SOUND " + x.Name.Content);
