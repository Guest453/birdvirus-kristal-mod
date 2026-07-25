local DEBUG_MODE_MENU = "birdvirus_debug_mode"
local DEBUG_LOAD_MENU = "birdvirus_debug_load_save"
local DEBUG_STATS_MENU = "birdvirus_debug_stats"
local DEBUG_PARTY_STATS_MENU = "birdvirus_debug_party_stats"
local DEBUG_PARTY_MEMBER_MENU = "birdvirus_debug_party_member"
local DEBUG_ENEMY_STATS_MENU = "birdvirus_debug_enemy_stats"
local DEBUG_ENEMY_MEMBER_MENU = "birdvirus_debug_enemy_member"

function Mod:init()
    print("Loaded " .. self.info.name .. "!")

    self.music_volumes = self.music_volumes or {}
    self.music_pitches = self.music_pitches or {}
    self.music_volumes["creepylandscape"] = 0.5
    self.music_pitches["creepylandscape"] = 0.95
    self.music_volumes["field_of_hopes"] = 0.7

    Game:registerEvent("mouseholeentry", function(data)
        return MouseholeEntry(data.x, data.y, { data.width, data.height })
    end)

    Game:registerEvent("climbshooter", function(data)
        -- timer_offset is a custom property! Let's read it here and pass it into our object.
        -- Same with shoot_speed.
        return ClimbShooter(data.x, data.y, { data.width, data.height }, data.properties.timer_offset, data.properties.shoot_speed)
    end)
end

function Mod:postInit(new_file)
    if new_file then
        Game:setFlag("purified", 0)
        Game:setFlag("slain", 0)
    end
end

function Mod:registerDebugOptions(debug)
    local selected_party_id
    local selected_enemy_index
    local selected_enemy_token

    local function inGame()
        return debug:isInGame()
    end

    local function inBattle()
        return inGame() and Game.state == "BATTLE" and Game.battle ~= nil
    end

    local function inOverworld()
        return inGame() and Game.state == "OVERWORLD" and Game.world ~= nil
    end

    local function availabilityDescription(available, ready, unavailable)
        return function()
            return available() and ready or unavailable
        end
    end

    local function availabilityColor(available)
        return function()
            return available() and COLORS.white or COLORS.silver
        end
    end

    local function enterWhenAvailable(available, menu)
        return function()
            if not available() then
                return false
            end
            debug:enterMenu(menu, 1)
        end
    end

    local function finiteNumber(text)
        local value = tonumber((text or ""):match("^%s*(.-)%s*$"))
        if not value or value ~= value or value == math.huge or value == -math.huge then
            return nil
        end
        return value
    end

    local function booleanValue(text)
        local value = (text or ""):match("^%s*(.-)%s*$"):lower()
        if value == "true" or value == "on" or value == "yes" or value == "1" then
            return true
        elseif value == "false" or value == "off" or value == "no" or value == "0" then
            return false
        end
    end

    local function openInput(title, prompt, current, parser, apply)
        debug.window = DebugWindow(title, prompt, "input", function(text)
            local value = parser(text)
            if value == nil or not apply(value) then
                Assets.playSound("ui_cant_select")
                return
            end
            Assets.playSound("impact")
        end)
        debug.window.input_lines[1] = tostring(current)
        debug.window:setPosition(Input.getCurrentCursorPosition())
        debug:addChild(debug.window)
    end

    local function clamp(value, minimum, maximum)
        if minimum ~= nil then
            value = math.max(minimum, value)
        end
        if maximum ~= nil then
            value = math.min(maximum, value)
        end
        return value
    end

    local function getPartyMember()
        return inGame() and Game.party_data and Game.party_data[selected_party_id] or nil
    end

    local function getEnemy()
        if not inBattle() or not Game.battle.enemies then
            return nil
        end
        local indexed = Game.battle.enemies[selected_enemy_index]
        if indexed and tostring(indexed) == selected_enemy_token then
            return indexed
        end
        for index, enemy in ipairs(Game.battle.enemies) do
            if tostring(enemy) == selected_enemy_token then
                selected_enemy_index = index
                return enemy
            end
        end
    end

    local function syncPartyBattler(member, light)
        if not inBattle() or Game:isLight() ~= light then
            return
        end
        for _, battler in ipairs(Game.battle.party or {}) do
            if battler.chara == member or (battler.chara and battler.chara.id == member.id) then
                if type(battler.checkHealth) == "function" then
                    battler:checkHealth(false)
                end
                break
            end
        end
    end

    local function effectiveStat(member, stat, light)
        if type(member.getStat) == "function" then
            local ok, value = pcall(member.getStat, member, stat, 0, light)
            if ok and type(value) == "number" then
                return value
            end
        end
        local stats = light and member.lw_stats or member.stats
        return type(stats) == "table" and tonumber(stats[stat]) or 0
    end

    local function reconcilePartyHealth(member, light)
        local health_key = light and "lw_health" or "health"
        local maximum = math.max(1, effectiveStat(member, "health", light))
        if type(member[health_key]) == "number" and member[health_key] > maximum then
            member[health_key] = maximum
        end
        if not light then
            syncPartyBattler(member, false)
        else
            syncPartyBattler(member, true)
        end
    end

    local function registerNumberOption(menu, name, description, resolve, read, write, settings)
        settings = settings or {}
        debug:registerOption(
            menu,
            name,
            function()
                local target = resolve()
                if not target then
                    return "the target is no longer available."
                end
                return description(target) .. " (current: " .. tostring(read(target)) .. ")"
            end,
            function()
                local target = resolve()
                if not target then
                    Assets.playSound("ui_cant_select")
                    return false
                end
                openInput(name, settings.prompt or "enter a finite number.", read(target), finiteNumber, function(value)
                    local live_target = resolve()
                    if not live_target then
                        return false
                    end
                    if settings.integer then
                        value = math.floor(value + 0.5)
                    end
                    value = clamp(value, settings.minimum, settings.maximum)
                    write(live_target, value)
                    return true
                end)
            end,
            function()
                return resolve() ~= nil
            end
        )
    end

    local function registerBooleanOption(menu, name, description, resolve, read, write)
        debug:registerOption(
            menu,
            name,
            function()
                local target = resolve()
                if not target then
                    return "the target is no longer available."
                end
                return description .. " (current: " .. tostring(read(target)) .. ")"
            end,
            function()
                local target = resolve()
                if not target then
                    Assets.playSound("ui_cant_select")
                    return false
                end
                openInput(name, "enter true/false, on/off, yes/no, or 1/0.", read(target), booleanValue, function(value)
                    local live_target = resolve()
                    if not live_target then
                        return false
                    end
                    write(live_target, value)
                    return true
                end)
            end,
            function()
                return resolve() ~= nil
            end
        )
    end

    local function resetMenu(menu)
        debug.menus[menu].options = {}
    end

    local function finishDynamicMenu()
        debug.current_selecting = 1
        debug:updateBounds(debug:getValidOptions())
    end

    local function buildPartyMemberMenu()
        resetMenu(DEBUG_PARTY_MEMBER_MENU)
        local member = getPartyMember()
        if not member then
            debug:registerOption(DEBUG_PARTY_MEMBER_MENU, "unavailable", "this loaded party member no longer exists.", function() return false end)
        else
            local base_fields = {
                { "dark base health", "health", 1 },
                { "dark base attack", "attack", 0 },
                { "dark base defense", "defense", 0 },
                { "dark base magic", "magic", 0 },
            }
            registerNumberOption(DEBUG_PARTY_MEMBER_MENU, "dark current hp", function(target)
                return "saved dark-world hp; effective maximum: " .. tostring(effectiveStat(target, "health", false)) .. "."
            end, getPartyMember, function(target) return target.health end, function(target, value)
                target.health = math.min(value, math.max(1, effectiveStat(target, "health", false)))
                syncPartyBattler(target, false)
            end, { minimum = -999999 })
            for _, field in ipairs(base_fields) do
                local field_data = field
                registerNumberOption(DEBUG_PARTY_MEMBER_MENU, field_data[1], function(target)
                    return "base value before equipment and buffs; effective: " .. tostring(effectiveStat(target, field_data[2], false)) .. "."
                end, getPartyMember, function(target) return target.stats[field_data[2]] end, function(target, value)
                    target.stats[field_data[2]] = value
                    if field_data[2] == "health" then reconcilePartyHealth(target, false) end
                end, { minimum = field_data[3] })
            end
            registerNumberOption(DEBUG_PARTY_MEMBER_MENU, "light current hp", function(target)
                return "saved light-world hp; effective maximum: " .. tostring(effectiveStat(target, "health", true)) .. "."
            end, getPartyMember, function(target) return target.lw_health end, function(target, value)
                target.lw_health = math.min(value, math.max(1, effectiveStat(target, "health", true)))
                syncPartyBattler(target, true)
            end, { minimum = 0 })
            for _, field in ipairs({ { "light base health", "health", 1 }, { "light base attack", "attack", 0 }, { "light base defense", "defense", 0 } }) do
                local field_data = field
                registerNumberOption(DEBUG_PARTY_MEMBER_MENU, field_data[1], function(target)
                    return "light-world base value; effective: " .. tostring(effectiveStat(target, field_data[2], true)) .. "."
                end, getPartyMember, function(target) return target.lw_stats[field_data[2]] end, function(target, value)
                    target.lw_stats[field_data[2]] = value
                    if field_data[2] == "health" then reconcilePartyHealth(target, true) end
                end, { minimum = field_data[3] })
            end
            registerNumberOption(DEBUG_PARTY_MEMBER_MENU, "dark level", function() return "saved dark-world display level." end,
                getPartyMember, function(target) return target.level end, function(target, value) target.level = value end,
                { minimum = 1, integer = true })
            registerNumberOption(DEBUG_PARTY_MEMBER_MENU, "light level", function() return "saved light-world level." end,
                getPartyMember, function(target) return target.lw_lv end, function(target, value) target.lw_lv = value end,
                { minimum = 1, integer = true })
            registerNumberOption(DEBUG_PARTY_MEMBER_MENU, "light exp", function() return "saved light-world experience." end,
                getPartyMember, function(target) return target.lw_exp end, function(target, value) target.lw_exp = value end,
                { minimum = 0, integer = true })

            local max_stat_names = {}
            for stat, value in pairs(member.max_stats or {}) do
                if type(stat) == "string" and type(value) == "number" then table.insert(max_stat_names, stat) end
            end
            table.sort(max_stat_names)
            for _, stat in ipairs(max_stat_names) do
                local stat_name = stat
                    registerNumberOption(DEBUG_PARTY_MEMBER_MENU, "max-stat cap: " .. stat_name, function()
                        return "numeric permanent-growth cap supplied by this party member."
                    end, getPartyMember, function(target) return target.max_stats[stat_name] end,
                    function(target, value) target.max_stats[stat_name] = value end, { minimum = 0 })
            end
            if type(member.stat_buffs) == "table" then
                local buff_names = {}
                for stat, value in pairs(member.stat_buffs) do
                    if type(stat) == "string" and type(value) == "number" then table.insert(buff_names, stat) end
                end
                table.sort(buff_names)
                for _, stat in ipairs(buff_names) do
                    local stat_name = stat
                    registerNumberOption(DEBUG_PARTY_MEMBER_MENU, "stat buff: " .. stat_name, function(target)
                        local effective = (stat_name == "health" or stat_name == "attack" or stat_name == "defense" or stat_name == "magic")
                            and (" effective: " .. tostring(effectiveStat(target, stat_name, false)) .. ".") or ""
                        return "temporary numeric stat buff." .. effective
                    end, getPartyMember, function(target) return target.stat_buffs[stat_name] end, function(target, value)
                        target.stat_buffs[stat_name] = value
                        if stat_name == "health" then reconcilePartyHealth(target, false) end
                    end)
                end
            end
        end
        debug:registerOption(DEBUG_PARTY_MEMBER_MENU, "back", "return to loaded party members.", function() debug:returnMenu() end)
        finishDynamicMenu()
    end

    local function buildPartyMenu()
        resetMenu(DEBUG_PARTY_STATS_MENU)
        local ids = {}
        for id, member in pairs((inGame() and Game.party_data) or {}) do
            if type(member) == "table" then table.insert(ids, id) end
        end
        table.sort(ids, function(a, b) return tostring(a) < tostring(b) end)
        for _, id in ipairs(ids) do
            local party_id = id
            debug:registerOption(DEBUG_PARTY_STATS_MENU, tostring(party_id), function()
                local current = Game.party_data and Game.party_data[party_id]
                return current and ("edit loaded member " .. tostring(current.name or party_id) .. ", including inactive members.") or "member is no longer loaded."
            end, function()
                if not inGame() or not Game.party_data[party_id] then return false end
                selected_party_id = party_id
                debug:enterMenu(DEBUG_PARTY_MEMBER_MENU, 1)
            end, function() return inGame() and Game.party_data and Game.party_data[party_id] ~= nil end)
        end
        debug:registerOption(DEBUG_PARTY_STATS_MENU, "back", "return to the stats editor.", function() debug:returnMenu() end)
        finishDynamicMenu()
    end

    local function buildEnemyMemberMenu()
        resetMenu(DEBUG_ENEMY_MEMBER_MENU)
        local enemy = getEnemy()
        if not enemy then
            debug:registerOption(DEBUG_ENEMY_MEMBER_MENU, "unavailable", "this runtime enemy no longer exists.", function() return false end)
        else
            local numeric_fields = {
                { "health", "health", 0 }, { "max health", "max_health", 1 },
                { "attack", "attack" }, { "defense", "defense" },
                { "mercy", "mercy", 0, 100 }, { "spare points", "spare_points", 0 },
                { "money", "money", 0 }, { "experience", "experience", 0 },
                { "graze tension", "graze_tension", 0 }, { "temporary mercy", "temporary_mercy", 0, 100 },
                { "tired hp threshold", "tired_percentage", 0, 1 },
                { "low-health threshold", "low_health_percentage", 0, 1 },
            }
            for _, field in ipairs(numeric_fields) do
                local field_data = field
                if type(enemy[field_data[2]]) == "number" then
                    registerNumberOption(DEBUG_ENEMY_MEMBER_MENU, field_data[1], function()
                        return "runtime-only enemy value; direct edits do not invoke damage or defeat callbacks."
                    end, getEnemy, function(target) return target[field_data[2]] end, function(target, value)
                        if field_data[2] == "health" and type(target.max_health) == "number" then
                            value = math.min(value, target.max_health)
                        end
                        target[field_data[2]] = value
                        if field_data[2] == "max_health" and type(target.health) == "number" then
                            target.health = math.min(target.health, value)
                        end
                    end, { minimum = field_data[3], maximum = field_data[4] })
                end
            end
            for _, field in ipairs({
                { "tired", "tired" }, { "auto spare", "auto_spare" }, { "can freeze", "can_freeze" },
                { "selectable", "selectable" }, { "disable mercy bar", "disable_mercy" }, { "exit on defeat", "exit_on_defeat" },
            }) do
                local field_data = field
                if type(enemy[field_data[2]]) == "boolean" then
                    registerBooleanOption(DEBUG_ENEMY_MEMBER_MENU, field_data[1], "runtime-only enemy boolean.", getEnemy,
                        function(target) return target[field_data[2]] end, function(target, value)
                            if field_data[2] == "tired" and type(target.setTired) == "function" then
                                target:setTired(value, true)
                            else
                                target[field_data[2]] = value
                            end
                        end)
                end
            end
        end
        debug:registerOption(DEBUG_ENEMY_MEMBER_MENU, "back", "return to active runtime enemies.", function() debug:returnMenu() end)
        finishDynamicMenu()
    end

    local function buildEnemyMenu()
        resetMenu(DEBUG_ENEMY_STATS_MENU)
        for index, enemy in ipairs((inBattle() and Game.battle.enemies) or {}) do
            local enemy_index = index
            debug:registerOption(DEBUG_ENEMY_STATS_MENU, tostring(enemy.name or enemy.id or "enemy") .. " #" .. enemy_index, function()
                local current = inBattle() and Game.battle.enemies[enemy_index]
                return current and "edit this active enemy's runtime-only stats." or "enemy is no longer active."
            end, function()
                if not inBattle() or not Game.battle.enemies[enemy_index] then return false end
                selected_enemy_index = enemy_index
                selected_enemy_token = tostring(Game.battle.enemies[enemy_index])
                debug:enterMenu(DEBUG_ENEMY_MEMBER_MENU, 1)
            end, function() return inBattle() and Game.battle.enemies[enemy_index] ~= nil end)
        end
        debug:registerOption(DEBUG_ENEMY_STATS_MENU, "back", "return to the stats editor.", function() debug:returnMenu() end)
        finishDynamicMenu()
    end

    debug:registerMenu(DEBUG_MODE_MENU, "Debug mode")
    debug:registerMenu(DEBUG_LOAD_MENU, "Debug mode - Load Save")
    debug:registerMenu(DEBUG_STATS_MENU, "stats editor")
    debug:registerMenu(DEBUG_PARTY_STATS_MENU, "loaded party members")
    debug:registerMenu(DEBUG_PARTY_MEMBER_MENU, "party member stats")
    debug:registerMenu(DEBUG_ENEMY_STATS_MENU, "active enemy runtime stats")
    debug:registerMenu(DEBUG_ENEMY_MEMBER_MENU, "enemy runtime stats")
    debug:registerMenuEntry(DEBUG_PARTY_STATS_MENU, buildPartyMenu)
    debug:registerMenuEntry(DEBUG_PARTY_MEMBER_MENU, buildPartyMemberMenu)
    debug:registerMenuEntry(DEBUG_ENEMY_STATS_MENU, buildEnemyMenu)
    debug:registerMenuEntry(DEBUG_ENEMY_MEMBER_MENU, buildEnemyMemberMenu)

    debug:registerOption(DEBUG_STATS_MENU, "party members", "edit saved base, current, level, cap, and buff values for every loaded member.",
        enterWhenAvailable(inGame, DEBUG_PARTY_STATS_MENU), nil, availabilityColor(inGame))
    debug:registerOption(DEBUG_STATS_MENU, "active enemies (runtime only)",
        availabilityDescription(inBattle, "edit active enemy values without damage or defeat callbacks.", "start a battle first."),
        enterWhenAvailable(inBattle, DEBUG_ENEMY_STATS_MENU), nil, availabilityColor(inBattle))
    debug:registerOption(DEBUG_STATS_MENU, "back", "return to debug mode.", function() debug:returnMenu() end)

    debug:registerOption(
        "main",
        "Debug mode",
        "Open Birdvirus's all-purpose debug menu. ([)",
        function()
            debug:enterMenu(DEBUG_MODE_MENU, 1)
        end
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Give Item",
        availabilityDescription(inGame, "Choose any registered item and put it in the inventory.", "Load a game first."),
        enterWhenAvailable(inGame, "give_item"),
        nil,
        availabilityColor(inGame)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Give Spell",
        availabilityDescription(inGame, "Give or remove any registered spell from any party member.", "Load a game first."),
        enterWhenAvailable(inGame, "give_spell"),
        nil,
        availabilityColor(inGame)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Stats Editor...",
        availabilityDescription(inGame, "edit all practical party stats and active enemy runtime stats.", "load a game first."),
        enterWhenAvailable(inGame, DEBUG_STATS_MENU),
        nil,
        availabilityColor(inGame)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Select Wave (for Enemies)",
        availabilityDescription(inBattle, "Assign selected waves to active enemies, then start them from ACTION SELECT.", "Start a battle first."),
        enterWhenAvailable(inBattle, "wave_select_multiple"),
        nil,
        availabilityColor(inBattle)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Set Flag...",
        availabilityDescription(inGame, "Set or create a flag with name=value. Values can be true, false, nil, numbers, or text.", "Load a game first."),
        function()
            if not inGame() or not Game.flags then
                return false
            end

            debug.window = DebugWindow(
                "Set Flag",
                "Enter name=value (example: birdvirus_party_selected=false).",
                "input",
                function(text)
                    local separator = string.find(text, "=", 1, true)
                    if not separator then
                        Assets.playSound("ui_cant_select")
                        return
                    end

                    local name = string.sub(text, 1, separator - 1):match("^%s*(.-)%s*$")
                    local raw_value = string.sub(text, separator + 1):match("^%s*(.-)%s*$")
                    if name == "" then
                        Assets.playSound("ui_cant_select")
                        return
                    end

                    local value
                    if raw_value == "true" then
                        value = true
                    elseif raw_value == "false" then
                        value = false
                    elseif raw_value == "nil" then
                        value = nil
                    elseif tonumber(raw_value) then
                        value = tonumber(raw_value)
                    else
                        value = raw_value:match('^"(.*)"$') or raw_value:match("^'(.*)'$") or raw_value
                    end

                    Game:setFlag(name, value)
                    Assets.playSound("impact")
                end
            )
            debug.window:setPosition(Input.getCurrentCursorPosition())
            debug:addChild(debug.window)
        end,
        nil,
        availabilityColor(inGame)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Flag Editor...",
        availabilityDescription(inGame, "Filter, inspect, and change every existing game flag.", "Load a game first."),
        function()
            if not inGame() or not Game.flags then
                return false
            end
            debug:setState("FLAGS")
        end,
        nil,
        availabilityColor(inGame)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Hotswap",
        "Reload changed code and assets without restarting the game.",
        function()
            Hotswapper.scan()
            debug:refresh()
            debug.menu_history = {}
            debug:enterMenu(DEBUG_MODE_MENU, 1, true)
        end
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Load Save...",
        availabilityDescription(inGame, "Choose save slot 1, 2, or 3 and load it immediately.", "Load a game first."),
        enterWhenAvailable(inGame, DEBUG_LOAD_MENU),
        nil,
        availabilityColor(inGame)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Reload Current Save",
        availabilityDescription(inGame, "Discard unsaved progress and reload the current save slot.", "Load a game first."),
        function()
            if not inGame() or Kristal.isLoading() then
                return false
            end
            debug:closeMenu()
            Kristal.quickReload("save")
        end,
        nil,
        availabilityColor(inGame)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Select Map",
        availabilityDescription(inOverworld, "Teleport directly to any registered map.", "Return to the overworld first."),
        enterWhenAvailable(inOverworld, "select_map"),
        nil,
        availabilityColor(inOverworld)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Start Encounter",
        availabilityDescription(inOverworld, "Start any registered encounter immediately.", "Return to the overworld first."),
        enterWhenAvailable(inOverworld, "encounter_select"),
        nil,
        availabilityColor(inOverworld)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Change Party",
        availabilityDescription(inGame, "Add or remove any registered party member.", "Load a game first."),
        enterWhenAvailable(inGame, "change_party"),
        nil,
        availabilityColor(inGame)
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "All Debug Options...",
        "Open Kristal's complete debug menu for money, noclip, cutscenes, shops, tests, battle controls, and more.",
        function()
            debug:enterMenu("main", 1)
        end
    )

    debug:registerOption(
        DEBUG_MODE_MENU,
        "Close Debug Mode",
        "Close the debug overlay and return control to the game.",
        function()
            debug:closeMenu()
        end
    )

    for slot = 1, 3 do
        local save_slot = slot
        debug:registerOption(
            DEBUG_LOAD_MENU,
            "Save Slot " .. save_slot,
            function()
                local data = Kristal.getSaveFile(save_slot)
                if not data then
                    return "Save slot " .. save_slot .. " is empty."
                end

                local name = tostring(data.name or "PLAYER")
                local level = data.level and (" - LV " .. tostring(data.level)) or ""
                return "Load " .. name .. level .. " from save slot " .. save_slot .. "."
            end,
            function()
                if Kristal.isLoading() or not Kristal.hasSaveFile(save_slot) then
                    return false
                end
                debug:closeMenu()
                Kristal.loadGame(save_slot, true)
            end,
            nil,
            function()
                return Kristal.hasSaveFile(save_slot) and COLORS.white or COLORS.silver
            end
        )
    end

    debug:registerOption(
        DEBUG_LOAD_MENU,
        "Back",
        "Return to Debug mode.",
        function()
            debug:returnMenu()
        end
    )
end

function Mod:getActionButtons(battler, buttons)
    if Game.battle and battler.chara.id == "susie" then
        for _, enemy in ipairs(Game.battle.enemies) do
            if enemy.id == "dummy" or (enemy.actor and enemy.actor.id == "dummy") then
                if not TableUtils.contains(buttons, "act") then
                    table.insert(buttons, 2, "act")
                end
                break
            end
        end
    end

    return buttons
end
