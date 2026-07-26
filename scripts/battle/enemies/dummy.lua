local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = "Birdvirus"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")

    self.float_timer = 0
    self.float_base_x = nil
    self.float_base_y = nil
    self.float_trail_timer = 0
    self.float_trail_points = {}
    self.float_trail_sprites = {}

    for i = 1, 6 do
        local trail = Sprite("birdvirus-001", 0, 0, nil, nil, "enemies/dummy")
        local sprite_layer = self.sprite and self.sprite.layer or 0

        trail:setLayer(sprite_layer - 1)
        trail:setColor(1, 1, 1, 0)
        self:addChild(trail)
        table.insert(self.float_trail_sprites, trail)
    end

    -- Enemy health
    self.max_health = 3200
    self.health = 3200
    -- Enemy attack (determines bullet damage)
    self.attack = 4
    -- Enemy defense (usually 0)
    self.defense = -7
    -- Enemy reward
    self.money = 999

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "knight_boxsplit_0",
        "knight_boxsplit_1",
        "knight_boxsplit_2",
        "knight_boxsplit_5",
        "knight_boxsplit_rain",
        "virus_explosions"
    }

    self.attack_count = 0
    self.fake_death_done = false
    self.fake_death_pending = false
    self.fake_death_type = nil
    self.noelle_route = false
    self.snowgrave_route = false
    self.phase_three_route = false
    self.phase_three_pending = false
    self.noelle_iceshock_uses = 0
    self.noelle_iceshock_dialogue_pending = false
    self.last_noelle_iceshock_action = nil
    self.last_noelle_boxsplit_wave = nil
    self.unvirus_unlocked = false
    self.unvirus_uses = 0
    self.unvirus_meter = 0
    self.unvirus_complete = false
    self.normal_bird = false
    self.unvirus_bar_ui = nil
    self.virus_damage_multiplier = 1
    self.call_kris_used = false
    self.call_kris_pending = false
    self.call_kris_repeat_pending = false

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "YOU'RE STILL HERE?",
        "I CAN HEAR YOUR SAVE FILE BREATHING.",
        "KEEP MOVING. IT MAKES THE CRASH FUNNIER.",
        "THAT SOUL DOESN'T BELONG TO YOU.",
        "I'M NOT AN ERROR. I'M WHAT SURVIVED ONE."
    }

    self:updateCheckText()

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Static crawls across Birdvirus's feathers.",
        "* Birdvirus watches the SOUL,[wait:5]\n  not the party.",
        "* The battle box flickers at its edges.",
        "* A corrupted chirp loops in the distance.",
        "* Birdvirus smiles like a broken warning sign.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Birdvirus's outline skips frames,[wait:5]\n  but its stare never moves."

    -- Register act called "Smile"
    self:registerAct("Calm down")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("Tell Story", "", {"ralsei"})
    -- This is a Susie ACT for this encounter, rather than a phase-two unlock.
    self:registerAct("Call Kris", "Call out for\nKris", {"susie"}, 0, nil, {"party/kris/head"})
end

function Dummy:updateCheckText()
    local defense = math.max(0, self.defense or 0)

    if self.normal_bird then
        self.check = "AT 0 DF 0\n* Just a small bird now.\n* The last of the virus is gone."
    elseif self.phase_three_route then
        self.check = "AT 4 DF "..defense.."\n* Something inside it has stopped pretending to be stable.\n* It is furious."
    elseif self.snowgrave_route then
        self.check = "AT 4 DF "..defense.."\n* SnowGrave did not finish it.\n* The wound is screaming through the static."
    elseif self.noelle_route then
        if defense > 0 then
            self.check = "AT 4 DF "..defense.."\n* A viral shell is freezing apart.\n* IceShock can break 3 more DEF."
        else
            self.check = "AT 4 DF 0\n* Its viral shell has shattered.\n* Nothing is protecting the core."
        end
    else
        self.check = "AT 4 DF "..defense.."\n* A furious bird wrapped in bad code.\n* It keeps watching the SOUL."
    end
end

function Dummy:updateFloat()
    if not self.sprite then
        return
    end

    if self.normal_bird and self.sprite.sprite ~= "birdvirus-001" then
        self.sprite:setSprite("birdvirus-001")
    end

    if not self.float_base_x then
        self.float_base_x = self.sprite.x
        self.float_base_y = self.sprite.y
    end

    self.float_timer = self.float_timer + DT

    local rage_speed = self.phase_three_route and 3.2 or (self.snowgrave_route and 2.15 or 1)
    local rage_distance = self.phase_three_route and 1.8 or (self.snowgrave_route and 1.45 or 1)
    local x = self.float_base_x + (math.sin(self.float_timer * 1.4 * rage_speed) * 10 * rage_distance)
    local y = self.float_base_y - 18 + (math.sin(self.float_timer * 2.2 * rage_speed) * 8 * rage_distance)

    self.sprite:setPosition(x, y)
    if self.overlay_sprite then
        self.overlay_sprite:setPosition(x, y)
    end

    if self.normal_bird then
        self.float_trail_points = {}
        for _, trail in ipairs(self.float_trail_sprites) do
            trail:setColor(1, 1, 1, 0)
        end
        return
    end

    self.float_trail_timer = self.float_trail_timer + DT
    if self.float_trail_timer >= 0.05 then
        table.insert(self.float_trail_points, 1, {
            x = x,
            y = y,
            sprite = self.sprite.sprite or "birdvirus-001",
        })
        self.float_trail_timer = 0

        while #self.float_trail_points > 18 do
            table.remove(self.float_trail_points)
        end
    end

    for i, trail in ipairs(self.float_trail_sprites) do
        local point = self.float_trail_points[i * 2]

        if point then
            local alpha = 0.28 * (1 - ((i - 1) / #self.float_trail_sprites))

            if trail.trail_sprite ~= point.sprite then
                trail:setSprite(point.sprite)
                trail.trail_sprite = point.sprite
            end
            trail:setPosition(point.x, point.y)
            trail:setScale(self.sprite.scale_x, self.sprite.scale_y)
            if self.phase_three_route then
                trail:setColor(0.75, 0.05, 1, math.min(0.62, alpha * 2))
            elseif self.snowgrave_route then
                trail:setColor(1, 0.12, 0.12, math.min(0.48, alpha * 1.6))
            else
                trail:setColor(1, 1, 1, alpha)
            end
        else
            trail:setColor(1, 1, 1, 0)
        end
    end
end

function Dummy:update()
    super.update(self)
    self:updateFloat()
end

function Dummy:selectWave()
    if self.normal_bird then
        self.selected_wave = nil
        return nil
    end

    if self.phase_three_route then
        local waves = self:getPhaseThreeWaves()
        return waves[1]
    end

    if self.snowgrave_route then
        local waves = self:getSnowgraveWaves()
        return waves[1]
    end

    self.attack_count = self.attack_count + 1

    if self.noelle_route then
        local cycle = {
            "virus_box_hunt",
            "knight_boxsplit_0",
            "virus_minigun",
            "knight_boxsplit_1",
            "virus_chase_burst",
            "knight_boxsplit_2",
            "virus_cross_explode",
            "knight_boxsplit_rain",
        }
        self.selected_wave = cycle[((self.attack_count - 1) % #cycle) + 1]
        self.last_noelle_boxsplit_wave = self.selected_wave
        return self.selected_wave
    end

    if self.wave_override then
        local wave = self.wave_override
        self.wave_override = nil
        self.selected_wave = wave
        return wave
    end

    local normal_cycle = {
        "birdpattern",
        "birddash",
        "knifedance",
        "knight_boxsplit_0",
        "knight_boxsplit_1",
        "knifedancering",
        "knifedancefast",
        "cornerknives",
        "virus_chase_burst",
        "virus_explosions",
        "knight_boxsplit_rain",
    }
    self.selected_wave = normal_cycle[((self.attack_count - 1) % #normal_cycle) + 1]
    return self.selected_wave
end

function Dummy:getPhaseThreeWaves()
    local cycle = {
        "knifedancefast",
        "virus_chase_burst",
        "knifedancering",
        "virus_box_hunt",
        "cornerknives",
        "virus_minigun",
        "knight_boxsplit_rain",
        "virus_cross_explode",
        "birddash",
        "virus_explosions",
    }

    self.attack_count = self.attack_count + 1
    self.selected_wave = cycle[((self.attack_count - 1) % #cycle) + 1]
    return {self.selected_wave}
end

function Dummy:getSnowgraveWaves()
    local rage_cycle = {
        {"birdpattern", "knifedance"},
        {"birddash", "virus_chase_burst"},
        {"knight_boxsplit_0"},
        {"knifedancering", "virus_box_hunt"},
        {"knight_boxsplit_1"},
        {"knifedancefast", "virus_minigun"},
        {"knight_boxsplit_2"},
        {"cornerknives", "virus_chase_burst"},
        {"knight_boxsplit_5"},
        {"virus_cross_explode", "knifedance"},
        {"knight_boxsplit_rain"},
        {"virus_explosions", "cornerknives"},
    }

    self.attack_count = self.attack_count + 1
    local waves = rage_cycle[((self.attack_count - 1) % #rage_cycle) + 1]
    self.selected_wave = waves[1]
    return TableUtils.copy(waves)
end

function Dummy:triggerFakeDeath()
    if not self.fake_death_done and not self.fake_death_pending then
        self.fake_death_pending = true
        self.health = 1
        self.defeated = false
        self.done_state = nil
        return
    end
end

function Dummy:triggerPhaseThree()
    if self.phase_three_route or self.phase_three_pending then
        return
    end

    self.phase_three_pending = true
    self.health = 1
    self.defeated = false
    self.done_state = nil
end

function Dummy:isPhaseTwo()
    return self.fake_death_done and not self.phase_three_route and not self.normal_bird
end

function Dummy:isIceShockAction(battler)
    if not battler or not battler.chara or battler.chara.id ~= "noelle" then
        return false
    end

    local action = Game.battle and Game.battle.current_processing_action
    local spell = action and action.action == "SPELL" and action.data
    if not spell then
        return false
    end

    local id = string.lower(tostring(spell.id or ""))
    local name = string.lower(tostring(spell.name or ""))
    local cast_name = spell.getCastName and string.lower(tostring(spell:getCastName())) or ""

    return id == "iceshock" or id == "ice_shock" or name == "iceshock" or name == "ice shock" or cast_name == "iceshock" or cast_name == "ice shock"
end

function Dummy:isSnowGraveAction(battler)
    if not battler or not battler.chara or battler.chara.id ~= "noelle" then
        return false
    end

    local action = Game.battle and Game.battle.current_processing_action
    local spell = action and action.action == "SPELL" and action.data
    if not spell then
        return false
    end

    local id = string.lower(tostring(spell.id or ""))
    local name = string.lower(tostring(spell.name or ""))
    local cast_name = spell.getCastName and string.lower(tostring(spell:getCastName())) or ""

    return id == "snowgrave" or id == "snow_grave"
        or name == "snowgrave" or name == "snow grave"
        or cast_name == "snowgrave" or cast_name == "snow grave"
end

function Dummy:applyNoelleIceShockDefenseBreak(battler)
    if self.snowgrave_route or not self.noelle_route or not self:isIceShockAction(battler) then
        return false
    end

    -- IceShock can invoke damage more than once internally; only count the current action once.
    local action = Game.battle and Game.battle.current_processing_action
    if not action or self.last_noelle_iceshock_action == action then
        return false
    end

    self.last_noelle_iceshock_action = action
    self.noelle_iceshock_uses = (self.noelle_iceshock_uses or 0) + 1
    self.noelle_iceshock_defense_before = math.max(0, self.defense or 0)
    self.defense = math.max(0, self.noelle_iceshock_defense_before - 3)
    self.noelle_iceshock_dialogue_pending = true
    self:updateCheckText()

    return true
end

function Dummy:isActiveKris(battler)
    return battler and battler.chara and battler.chara.id == "kris"
        and battler.parent and (not battler.isActive or battler:isActive())
end

function Dummy:unlockUnvirus()
    if self.noelle_route then
        return
    end

    if not self.unvirus_unlocked then
        self.unvirus_unlocked = true
        self.unvirus_meter = 0
        self:registerAct("Unvirus", "Fill virus\nbar", {"susie"})
        if Game.battle and (not self.unvirus_bar_ui or not self.unvirus_bar_ui.parent) then
            self.unvirus_bar_ui = Registry.createObject("birdvirus_tp_bar", self)
            Game.battle:addChild(self.unvirus_bar_ui)
        end
    end
end

function Dummy:scaleDamage(amount)
    return math.max(1, math.ceil(amount * (self.virus_damage_multiplier or 1)))
end

function Dummy:useUnvirus(battler)
    if self.noelle_route or self.unvirus_complete then
        return 0, false
    end

    self.unvirus_uses = self.unvirus_uses + 1
    self.virus_damage_multiplier = math.max(0.25, (self.virus_damage_multiplier or 1) - 0.15)

    local old_meter = self.unvirus_meter or 0
    local gain = math.min(25, 100 - old_meter)
    self.unvirus_meter = old_meter + gain
    self:addMercy(gain)

    local x, y = self:getRelativePos(self.width / 2, self.height / 2)
    local explosion = Explosion(x, y)
    explosion.layer = BATTLE_LAYERS["above_arena"] or 1000
    explosion:setScale(0.45)
    Game.battle:addChild(explosion)

    local sound = Assets.playSound("explosion_firework", 0.55)
    if sound then
        sound:setPitch(1.65)
    end

    self:hurt(15, battler)

    local completed = self.unvirus_meter >= 100
    if completed then
        self:becomeNormalBird()
    end

    return gain, completed
end

function Dummy:becomeNormalBird()
    if self.normal_bird then
        return
    end

    self.unvirus_complete = true
    self.normal_bird = true
    self.name = "Bird"
    self.attack = 0
    self.defense = 0
    self.virus_damage_multiplier = 0.25
    self.wave_override = nil
    self.current_target = "ANY"
    self.dialogue = {
        "chirp.",
        "...chirp?",
        "chirp chirp."
    }
    self.text = {
        "* The little bird smooths its feathers.",
        "* There is no static left in its voice.",
        "* The bird looks at Susie without fear."
    }
    self.low_health_text = nil
    -- Keep the clean white bird frame, but stop its infected animation and afterimage trail.
    self:setSprite("birdvirus-001")
    self:updateCheckText()
end

function Dummy:getSpareText(battler, success)
    if success and self.normal_bird then
        return {
            "* Susie spared the little bird.",
            "* It fluttered close,[wait:5] rested beside her,[wait:5] and gave one quiet chirp.",
            "* \"67\"[wait:10]\n* Without the static,[wait:5] the words were easy to understand.",
            "* For some reason, Susie was really pissed off by that number."
        }
    end

    return super.getSpareText(self, battler, success)
end

function Dummy:hurt(amount, battler, on_defeat, color, show_status, attacked)
    -- The defense break belongs to casting IceShock, even if defense reduces this hit to zero.
    local recognized_iceshock = self:isIceShockAction(battler)
    if self.phase_three_route and recognized_iceshock then
        local action = Game.battle and Game.battle.current_processing_action
        if not action or self.last_phase_three_iceshock_action == action then
            return
        end
        self.last_phase_three_iceshock_action = action
        amount = math.max(amount, 500)
    end

    local route_iceshock = self.noelle_route and not self.snowgrave_route and not self.phase_three_route and recognized_iceshock
    local first_iceshock_hit = self:applyNoelleIceShockDefenseBreak(battler)

    if route_iceshock then
        -- IceShock may call hurt multiple times for one spell action. Apply one final,
        -- visible hit, with a deterministic floor, rather than adding bonus damage.
        if not first_iceshock_hit then
            return
        end
        amount = math.max(amount, 160)
    end

    -- SnowGrave always gets its own route, even if it is cast after the IceShock phase
    -- or its raw damage would not quite empty Birdvirus's full health bar.
    if amount > 0 and not self.snowgrave_route and not self.fake_death_pending and self:isSnowGraveAction(battler) then
        self.fake_death_type = "noelle_snowgrave"
        self.fake_death_done = false

        local capped_amount = math.max(self.health - 1, 0)
        if capped_amount > 0 then
            super.hurt(self, capped_amount, battler, nil, color, show_status, attacked)
        else
            self.health = 1
        end

        self:triggerFakeDeath()
        return
    end

    if amount > 0 and not self.fake_death_done and (self.health - amount) <= 0 then
        if self:isIceShockAction(battler) then
            self.fake_death_type = "noelle_iceshock"
        end

        local capped_amount = math.max(self.health - 1, 0)

        if capped_amount > 0 then
            super.hurt(self, capped_amount, battler, nil, color, show_status, attacked)
        else
            self.health = 1
        end

        self:triggerFakeDeath()
        return
    end

    if amount > 0 and self:isPhaseTwo() and (self.health - amount) <= 0
        and (self:isActiveKris(battler) or recognized_iceshock) then
        local capped_amount = math.max(self.health - 1, 0)
        if capped_amount > 0 then
            super.hurt(self, capped_amount, battler, nil, color, show_status, attacked)
        else
            self.health = 1
        end
        self:triggerPhaseThree()
        return
    end

    return super.hurt(self, amount, battler, on_defeat, color, show_status, attacked)
end

function Dummy:checkHealth(on_defeat, amount, battler)
    if self.health <= 0 and not self.fake_death_done then
        self.health = 1
        self:triggerFakeDeath()
        return
    end

    return super.checkHealth(self, on_defeat, amount, battler)
end

function Dummy:onDefeat(damage, battler)
    if not self.fake_death_done then
        self:triggerFakeDeath()
        return
    end

    return super.onDefeat(self, damage, battler)
end

function Dummy:onAct(battler, name)
    if name == "Calm down" then
        -- Give the enemy 100% mercy
        self:addMercy(0)
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "DON'T SMILE LIKE YOU KNOW HOW THIS ENDS."
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You offer Birdvirus a careful smile.",
            "* Its expression copies yours one frame too late.[wait:5]\n* Nothing changes.",
        }

    elseif name == "Unvirus" then
        if not self.unvirus_unlocked or self.noelle_route or self.phase_three_route then
            return "* Susie tried something.[wait:5]\n* Nothing happened."
        end

        if self.unvirus_complete then
            return "* The virus is already gone.[wait:5]\n* The little bird is ready to be SPARED."
        end

        local gain, completed = self:useUnvirus(battler)
        local power = math.floor((self.virus_damage_multiplier or 1) * 100)

        if completed then
            return {
                "* Susie grabbed the final knot of code.",
                "* She pulled.[wait:10]\n* The static peeled away from Birdvirus in one long strand.",
                "* Underneath was a small,[wait:5] ordinary bird.",
                "* The UNVIRUS bar is full.[wait:5]\n* The bird can now be SPARED."
            }
        end

        return {
            "* Susie grabbed a strand of code trailing from Birdvirus.",
            "* She tore it loose.[wait:5]\n* A tiny blast dealt 15 damage.",
            "* The UNVIRUS bar filled by "..gain.."%.[wait:5]\n* Birdvirus's attacks weakened.",
            "* Virus strength fell to "..power.."%."
        }

    elseif name == "Call Kris" then
        local first_use = self:isPhaseTwo() and not self.call_kris_used
        self.call_kris_used = self.call_kris_used or first_use
        self.call_kris_pending = true
        self.call_kris_repeat_pending = self:isPhaseTwo() and not first_use
        -- A non-nil ACT result lets the action processor finish before the encounter
        -- starts the queued dialogue cutscene from getDialogueCutscene().
        return "* Susie called for Kris."

    elseif name == "Tell Story" then
        return {
            "* Ralsei told a gentle story about finding your way home.",
            "* Birdvirus..[wait:5]\n* He didnt even listen."
        }
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(0)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.[wait:5]\n* Birdvirus showed no interest."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." reached toward the frozen static.\n* Birdvirus recoiled before she touched it."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Dummy
