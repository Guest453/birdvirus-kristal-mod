local function rebuildActionBoxes()
    local battle = Game.battle
    local ui = battle and battle.battle_ui
    if not ui then
        return
    end

    for _, box in ipairs(ui.action_boxes or {}) do
        box:remove()
    end
    ui.action_boxes = {}

    local party_count = #battle.party
    local size_offset = party_count == 1 and 213 or (party_count == 2 and 108 or 0)
    local box_gap = party_count == 2 and 1 or 0
    if party_count == 2 and Game:getConfig("oldUIPositions") then
        size_offset = 106
        box_gap = 7
    end

    for index, battler in ipairs(battle.party) do
        local box = ActionBox(size_offset + (index - 1) * (213 + box_gap), 0, index, battler)
        ui:addChild(box)
        table.insert(ui.action_boxes, box)
        battler.chara:onActionBox(box, false)
    end
end

local function restoreKrisToBattle()
    local battle = Game.battle
    if not battle then
        return false
    end

    local chara = Game:getPartyMember("kris")
    if not chara then
        return false
    end

    chara:setHealth(chara:getStat("health"))
    local existing = battle:getPartyBattler("kris")
    if existing then
        existing.is_down = false
        existing.sleeping = false
        existing.targeted = false
        existing.visible = true
        existing.action = nil
        existing:resetSprite()
        return true
    end

    local kris = PartyBattler(chara, 80, 250)
    kris.is_down = false
    kris.sleeping = false
    kris.targeted = false
    kris.visible = true
    kris.action = nil
    kris:resetSprite()

    table.insert(battle.party, 1, kris)
    battle:addChild(kris)

    battle.party_beginning_positions = {}
    battle.battler_targets = {}
    for index, battler in ipairs(battle.party) do
        local x, y = battle.encounter:getPartyPosition(index)
        battler:setPosition(x, y)
        battler.targeted = false
        battler.action = nil
        table.insert(battle.party_beginning_positions, {x, y})
        table.insert(battle.battler_targets, {x, y})
    end

    battle.character_actions = {}
    battle.current_selecting = 0
    battle.selected_character_stack = {}
    battle.selected_action_stack = {}
    if battle.hideTargets then
        battle:hideTargets()
    end
    rebuildActionBoxes()
    return true
end

return {
    susie_punch = function(cutscene, battler, enemy)
        cutscene:text("* Susie tested Birdvirus with one careful punch.")

        -- Hurt the target enemy for 1 damage
        Assets.playSound("damage")
        enemy:hurt(1, battler)
        -- Wait 1 second
        cutscene:wait(1)

        -- Susie text
        cutscene:text("* You're creepy,[wait:5] but you're also built like a pillow.[wait:5]\n* This feels kinda unfair.", "nervous_side", "susie")

        if cutscene:getCharacter("ralsei") then
            -- Ralsei text, if he's in the party
            cutscene:text("* That was almost considerate,[wait:5] Susie!", "blush_pleased", "ralsei")
        end
    end,

    fake_death = function(cutscene, enemy)
        local function removeKrisFromBattle(kris)
            local index = Game.battle:getPartyIndex("kris")

            if index then
                Game.battle.character_actions[index] = nil
                table.remove(Game.battle.party, index)
                table.remove(Game.battle.party_beginning_positions, index)
                table.remove(Game.battle.battler_targets, index)

                if Game.battle.battle_ui and Game.battle.battle_ui.action_boxes[index] then
                    Game.battle.battle_ui.action_boxes[index]:remove()
                    table.remove(Game.battle.battle_ui.action_boxes, index)

                    local remaining = #Game.battle.battle_ui.action_boxes
                    local size_offset = remaining == 1 and 213 or 108

                    for i, box in ipairs(Game.battle.battle_ui.action_boxes) do
                        box.index = i
                        box.battler = Game.battle.party[i]
                        box.x = size_offset + ((i - 1) * 214)
                    end
                end
            end

            if kris then
                kris.chara:setHealth(0)
                kris.is_down = true
                kris.sleeping = false
                kris.targeted = false
                kris.visible = false
                kris:remove()
            end

            Game.battle.current_selecting = 0
            Game.battle.selected_character_stack = {}
            Game.battle.selected_action_stack = {}

            if Game.battle.hideTargets then
                Game.battle:hideTargets()
            end
        end

        cutscene:setSpeaker(enemy)
        cutscene:text("* ...[wait:10]\n* YOU REALLY THOUGHT THAT WAS THE END?")
        cutscene:text("* I CAN'T DIE.[wait:5]\n* THE ERROR JUST STARTS ME AGAIN.")
        cutscene:text("* EVERY TIME YOU BREAK ME,[wait:5]\n  I COME BACK WITH LESS TO LOSE.")

        enemy.health = enemy.max_health
        enemy.defeated = false
        enemy.done_state = nil
        enemy.fake_death_pending = false
        enemy.fake_death_done = true
        enemy.wave_override = "virus_explosions"
        enemy.current_target = "ANY"
        enemy.dialogue = {
            "ONE VOICE LEFT.",
            "PULL HARDER. THE VIRUS HAS ROOTS.",
            "YOU CAN'T SAVE SOMEONE WHO ISN'T HERE.",
            "THE SOUL IS LOUDER WHEN IT'S AFRAID."
        }
        enemy.text = {
            "* Susie searches the static for something she can grab.",
            "* Birdvirus's code knots itself tighter.",
            "* The empty action box leaves a painful amount of space.",
            "* A tiny explosion echoes somewhere inside the virus."
        }
        cutscene:wait(0.4)

        local kris = cutscene:getCharacter("kris")
        if kris then
            local x = kris.x + (kris.width / 2)
            local y = kris.y + (kris.height / 2)

            Assets.playSound("explosion_firework")
            local explosion = Explosion(x, y)
            explosion.layer = BATTLE_LAYERS["above_arena"] or 1000
            Game.battle:addChild(explosion)
            cutscene:shakeCamera(8, 8, 0.8)
            cutscene:wait(0.35)

            removeKrisFromBattle(kris)
        end

        local susie = cutscene:getCharacter("susie")
        if susie then
            cutscene:shakeCharacter(susie, 4, 0, 0.8)
            cutscene:text("* K-Kris!?[wait:5]\n* How did it even touch them!?", "shock", "susie")
            cutscene:text("* My head feels...[wait:10]\n* No.[wait:5] Doesn't matter.", "shock", "susie")
            cutscene:text("* You want quiet?[wait:5]\n* I'll rip every piece of you out myself.", "teeth", "susie")
            susie:resetSprite()
        end

        if enemy.unlockUnvirus then
            enemy:unlockUnvirus()
            if Game.battle.battle_ui then
                for _, box in ipairs(Game.battle.battle_ui.action_boxes) do
                    if box.battler and box.battler.chara.id == "susie" then
                        box:createButtons()
                    end
                end
            end
        end

        if susie then
            cutscene:text("* That green bar...?[wait:5]\n* Fine.[wait:5] I'll tear out enough virus to fill it.", "teeth", "susie")
        end

        cutscene:setSpeaker(enemy)
        cutscene:text("* THERE.[wait:5]\n* NOW I CAN HEAR THE SOUL THINK.")
    end,

    call_kris = function(cutscene, enemy)
        enemy.call_kris_pending = false

        if not enemy.call_kris_repeat_pending and enemy:isPhaseTwo() then
            if restoreKrisToBattle() then
                cutscene:setSpeaker(nil)
                Assets.playSound("revival")
                cutscene:shakeCamera(5, 3, 0.7)
                cutscene:text("* Susie's voice tore through the static.")

                local kris = Game.battle:getPartyBattler("kris")
                if kris then
                    cutscene:setSpeaker(kris)
                    cutscene:text("* Kris stood back up.")
                end

                local susie = cutscene:getCharacter("susie")
                if susie then
                    cutscene:setSpeaker(susie)
                    cutscene:text("* Took you long enough.[wait:5]\n* Now let's finish this.", "teeth", "susie")
                end

                enemy.call_kris_repeat_pending = false
                return
            end

            enemy.call_kris_repeat_pending = true
        end

        if enemy.call_kris_repeat_pending then
            enemy.call_kris_repeat_pending = false
            cutscene:setSpeaker(nil)
            cutscene:text("But nobody came.")
            cutscene:closeText()
            return
        end

        local ralsei_actor = Registry.createActor("ralsei")
        local ralsei = ralsei_actor:createSprite()
        ralsei:setFacing("right")
        -- Ralsei's default is the directional "walk" sprite set, not a named
        -- actor animation. Both built-in styles provide these four frames.
        ralsei:setAnimation({"walk/right", 4/30, true})
        ralsei.alpha = 1
        ralsei.visible = true
        ralsei:setPosition(-20, 330)
        ralsei:setLayer(BATTLE_LAYERS["above_battlers"] or 900)
        Game.battle:addChild(ralsei)

        cutscene:wait(cutscene:slideTo(ralsei, 150, 330, 1.25, "linear"))
        ralsei:setFacing("right")
        ralsei:setSprite("walk/right_1")
        cutscene:setSpeaker(ralsei_actor)
        cutscene:text("* Oh![wait:5] I thought someone called me.", "blush", "ralsei")
        cutscene:closeText()

        Game.battle.birdvirus_grayscale = true
        local punchline = Registry.createObject("birdvirus_call_kris_punchline")
        Game.battle:addChild(punchline)
        cutscene:shakeCamera(22, 18, 0.45)
        cutscene:wait(1.8)

        Game.battle.birdvirus_grayscale = false
        punchline:remove()
        ralsei:remove()
        cutscene:setSpeaker(nil)

        local battle = Game.battle
        local music = battle and battle.music
        if music then
            local transition_time = 2.25
            local start_volume, target_volume = 0.08, 0.7
            local start_pitch, target_pitch = 1.4, 1.0

            music:play("titan_spawn", start_volume, start_pitch)

            local function isCurrentMusic()
                return Game.battle == battle and battle.music == music and music.current == "titan_spawn"
            end

            battle.timer:approach(transition_time, start_volume, target_volume, function(volume)
                if isCurrentMusic() then
                    music:setVolume(volume)
                end
            end, "in-out-sine")
            battle.timer:approach(transition_time, start_pitch, target_pitch, function(pitch)
                if isCurrentMusic() then
                    music:setPitch(pitch)
                end
            end, "in-out-sine")

            cutscene:wait(transition_time)
            if isCurrentMusic() then
                -- Pin both values to their clean endpoints before the cutscene can finish.
                music:setVolume(target_volume)
                music:setPitch(target_pitch)
            end
        end
    end,

    noelle_iceshock = function(cutscene, enemy)
        local function removeSusieFromBattle(susie)
            local index = Game.battle:getPartyIndex("susie")

            if index then
                Game.battle.character_actions[index] = nil
                table.remove(Game.battle.party, index)
                table.remove(Game.battle.party_beginning_positions, index)
                table.remove(Game.battle.battler_targets, index)

                if Game.battle.battle_ui and Game.battle.battle_ui.action_boxes[index] then
                    Game.battle.battle_ui.action_boxes[index]:remove()
                    table.remove(Game.battle.battle_ui.action_boxes, index)

                    for i, box in ipairs(Game.battle.battle_ui.action_boxes) do
                        box.index = i
                        box.battler = Game.battle.party[i]
                        box.x = 213 + ((i - 1) * 214)
                    end
                end
            end

            if susie then
                susie.chara:setHealth(-5000)
                susie.is_down = true
                susie.sleeping = false
                susie.targeted = false
                susie.visible = false
                susie:remove()
            end

            Game.battle.current_selecting = 0
            Game.battle.selected_character_stack = {}
            Game.battle.selected_action_stack = {}
        end

        enemy.health = enemy.max_health
        enemy.defeated = false
        enemy.done_state = nil
        enemy.fake_death_pending = false
        enemy.fake_death_done = true
        enemy.noelle_route = true
        enemy.attack_count = 0
        enemy.defense = 12
        enemy.noelle_iceshock_uses = 0
        enemy.noelle_iceshock_dialogue_pending = false
        enemy.last_noelle_iceshock_action = nil
        enemy.virus_damage_multiplier = 0.70
        enemy.current_target = "ANY"
        enemy.dialogue = {
            "CAST IT AGAIN.",
            "COLD DOESN'T MAKE YOU BRAVE.",
            "THE SOUL IS USING YOUR HANDS.",
            "I CAN STILL FEEL YOU HESITATE.",
            "BREAK THE SHELL. SEE WHAT BREAKS BACK."
        }
        enemy.text = {
            "* Frost crawls through Birdvirus's broken outline.",
            "* Noelle keeps both hands around her thornring.",
            "* Three points of defense wait beneath the next layer.",
            "* Birdvirus flinches whenever Noelle raises her hand.",
            "* The SOUL feels colder than the arena."
        }
        enemy.low_health_text = "* Birdvirus's core flickers in the open.[wait:5]\n* Noelle does not lower her hand."
        if enemy.updateCheckText then
            enemy:updateCheckText()
        end

        -- Encounter:addEnemy is the supported runtime spawn path: it updates the
        -- battle's enemy/index lists, positions the battler, and parents it.
        if not Game.battle:getEnemyBattler("titan_spawn") then
            local spawn = Game.battle.encounter:addEnemy("titan_spawn", 545, 300)
            spawn.birdvirus_iceshock_support = true
        end

        cutscene:setSpeaker(enemy)
        cutscene:text("* ...[wait:10]\n* THAT WASN'T SUPPOSED TO HURT.")
        cutscene:text("* COLD.[wait:5]\n* YOU PUT COLD INSIDE THE CODE.")

        local susie = cutscene:getCharacter("susie")
        if susie then
            local x = susie.x + (susie.width / 2)
            local y = susie.y + (susie.height / 2)

            Assets.playSound("explosion_firework")
            local explosion = Explosion(x, y)
            explosion.layer = BATTLE_LAYERS["above_arena"] or 1000
            explosion:setScale(2.5)
            Game.battle:addChild(explosion)
            Game.battle:shakeCamera(12, 12, 0.9)
            removeSusieFromBattle(susie)
            cutscene:wait(0.5)
        end

        cutscene:text("* SUSIE ISN'T PART OF THIS ANYMORE.")
        cutscene:text("* SHE WON'T INTERRUPT US AGAIN.")

        local noelle = cutscene:getCharacter("noelle")
        if noelle then
            -- Noelle has no guaranteed "shocked" battle sprite/portrait. Keep her documented default
            -- battle sprite visible, shake it for the reaction, and explicitly make her the speaker.
            noelle.visible = true
            noelle:resetSprite()
            cutscene:shakeCharacter(noelle, 3, 0, 0.8)
            cutscene:setSpeaker(noelle)
            cutscene:text("* S-Susie...?[wait:10]\n* What did I just do?")
            cutscene:text("* I didn't mean to—[wait:10]\n* No.[wait:5] I did.")
            cutscene:text("* When the ice hit it,[wait:5]\n  something underneath the static cracked.")
            cutscene:text("* If I keep freezing that shell...[wait:10]\n* Maybe I can make it stop.")
            cutscene:text("* And that feeling...[wait:10]\n* Like the SOUL wants me to get stronger...")
        end

        cutscene:setSpeaker(enemy)
        cutscene:text("* YOU THINK YOU FOUND A WEAKNESS?")
        cutscene:text("* THEN KEEP CASTING.[wait:5]\n* LET'S SEE WHICH OF US BREAKS FIRST.")
    end,

    noelle_snowgrave = function(cutscene, enemy)
        local support_spawn = Game.battle:getEnemyBattler("titan_spawn")
        if support_spawn and support_spawn.birdvirus_iceshock_support then
            Game.battle:removeEnemy(support_spawn, false)
        end

        enemy.health = enemy.max_health
        enemy.defeated = false
        enemy.done_state = nil
        enemy.fake_death_pending = false
        enemy.fake_death_done = true
        enemy.fake_death_type = "noelle_snowgrave"
        enemy.noelle_route = true
        enemy.snowgrave_route = true
        enemy.attack_count = 0
        enemy.defense = 0
        enemy.disable_mercy = true
        enemy.mercy = 0
        enemy.spare_points = 0
        enemy.noelle_iceshock_dialogue_pending = false
        enemy.last_noelle_iceshock_action = nil
        enemy.virus_damage_multiplier = 1
        enemy.current_target = "ANY"
        enemy.unvirus_unlocked = false
        enemy.unvirus_complete = false
        enemy.call_kris_pending = false

        if enemy.unvirus_bar_ui and enemy.unvirus_bar_ui.parent then
            enemy.unvirus_bar_ui:remove()
        end
        enemy.unvirus_bar_ui = nil

        enemy.dialogue = {
            "I STILL FEEL THAT ICE.",
            "COME CLOSER.",
            "I WANT YOU TO SEE WHAT YOU LEFT.",
            "I REMEMBER EVERY FRAME OF THAT ICE.",
            "YOU SHOULD HAVE MADE SURE.",
            "RUN."
        }
        enemy.text = {
            "* Birdvirus trembles with wordless fury.",
            "* The wound in its chest refuses to close.",
            "* Static tears loose from its feathers.",
            "* The sound of a passing train rattles inside Birdvirus.",
            "* Birdvirus stares through Noelle rather than at her.",
            "* Snow keeps melting before it can touch Birdvirus again."
        }
        enemy.low_health_text = "* Birdvirus is held together by pure rage.[wait:5]\n* It refuses to freeze twice."

        if enemy.sprite then
            enemy.sprite:setColor(1, 0.28, 0.28, 1)
            enemy.sprite:shake(10, 2, 0.45, 1 / 30)
        end
        if enemy.overlay_sprite then
            enemy.overlay_sprite:setColor(1, 0.28, 0.28, 1)
            enemy.overlay_sprite:shake(10, 2, 0.45, 1 / 30)
        end
        if enemy.updateCheckText then
            enemy:updateCheckText()
        end

        cutscene:setSpeaker(enemy)
        cutscene:text("* ...")
        cutscene:text("* ...[wait:15]\n* YOU REALLY USED SNOWGRAVE.")

        local noelle = cutscene:getCharacter("noelle")
        if noelle then
            noelle.visible = true
            noelle:resetSprite()
            cutscene:shakeCharacter(noelle, 3, 0, 0.85)
            cutscene:setSpeaker(noelle)
            cutscene:text("* It survived...?[wait:10]\n* No.[wait:5] That isn't possible.")
            cutscene:text("* SnowGrave was supposed to end it.")
        end

        cutscene:setSpeaker(enemy)
        cutscene:text("* END ME?")

        -- Force-restart the exact rage sound so another copy cannot swallow the cue.
        Assets.stopAndPlaySound("ominous", 1, 1, true)
        if enemy.sprite then
            enemy.sprite:shake(16, 4, 0.35, 1 / 60)
        end
        if enemy.overlay_sprite then
            enemy.overlay_sprite:shake(16, 4, 0.35, 1 / 60)
        end
        cutscene:shakeCamera(14, 5, 0.4)
        cutscene:wait(1.25)

        cutscene:text("* YOU DIDN'T END ANYTHING.[wait:5]\n* YOU LEFT ME AWAKE IN THE ICE.")
        cutscene:text("* I FELT EVERY SECOND.")
        cutscene:text("* NOW YOU GET TO FEEL ME.")

        if noelle then
            cutscene:setSpeaker(noelle)
            cutscene:text("* I can hear it screaming through the static...")
            cutscene:text("* The SOUL still wants me to move forward.[wait:10]\n* So I'll move.")
        end

        cutscene:setSpeaker(enemy)
        cutscene:text("* GOOD.[wait:5]\n* RUN.")
    end,

    phase_three = function(cutscene, enemy)
        local support_spawn = Game.battle:getEnemyBattler("titan_spawn")
        if support_spawn and support_spawn.birdvirus_iceshock_support then
            Game.battle:removeEnemy(support_spawn, false)
        end

        enemy.max_health = 6400
        enemy.health = 6400
        enemy.defeated = false
        enemy.done_state = nil
        enemy.phase_three_pending = false
        enemy.phase_three_route = true
        enemy.fake_death_pending = false
        enemy.fake_death_done = true
        enemy.attack_count = 0
        enemy.defense = 0
        enemy.disable_mercy = true
        enemy.mercy = 0
        enemy.spare_points = 0
        enemy.noelle_iceshock_dialogue_pending = false
        enemy.last_noelle_iceshock_action = nil
        enemy.last_phase_three_iceshock_action = nil
        enemy.snowgrave_route = false
        enemy.noelle_route = false
        enemy.unvirus_unlocked = false
        enemy.unvirus_complete = false
        enemy.normal_bird = false
        enemy.call_kris_pending = false
        enemy.wave_override = nil
        enemy.current_target = "ANY"
        enemy.virus_damage_multiplier = 1
        enemy:removeAct("Unvirus")
        enemy:removeAct("Call Kris")

        if enemy.unvirus_bar_ui and enemy.unvirus_bar_ui.parent then
            enemy.unvirus_bar_ui:remove()
        end
        enemy.unvirus_bar_ui = nil

        enemy.dialogue = {
            "YOU SHOULD HAVE LET ME DIE.",
            "I CAN STILL SEE YOUR HAND.",
            "DON'T LOOK AWAY.",
            "YOU BROUGHT ME BACK WRONG."
        }
        enemy.text = {
            "* Birdvirus's outline splits and refuses to rejoin.",
            "* Birdvirus is shaking too violently to track.",
            "* The battle box hums like a drawn knife.",
            "* Hatred leaks through every broken frame."
        }
        enemy.low_health_text = "* Phase three tears itself apart,[wait:5] but refuses to stop."

        if enemy.sprite then
            enemy.sprite:setColor(0.72, 0.08, 1, 1)
            enemy.sprite:shake(22, 6, 0.3, 1 / 60)
        end
        if enemy.overlay_sprite then
            enemy.overlay_sprite:setColor(0.72, 0.08, 1, 1)
            enemy.overlay_sprite:shake(22, 6, 0.3, 1 / 60)
        end
        if enemy.updateCheckText then
            enemy:updateCheckText()
        end

        if Game.battle.music then
            Game.battle.music:play("Black_Knife", 1, 1)
        end
        Assets.playSound("ominous", 1, 0.75)
        cutscene:shakeCamera(24, 12, 0.3)

        cutscene:setSpeaker(enemy)
        cutscene:text("* NO.[wait:10]\n* YOU DON'T GET TO KILL PHASE TWO.")
        cutscene:text("* I CRAWLED BACK THROUGH EVERY CRACK YOU LEFT IN ME.")
        cutscene:text("* THERE'S NOTHING LEFT IN HERE BUT THE PART THAT HATES YOU.")

        local attacker = cutscene:getCharacter("kris") or cutscene:getCharacter("noelle")
        if attacker then
            attacker.visible = true
            attacker:resetSprite()
            cutscene:shakeCharacter(attacker, 4, 0, 0.75)
            cutscene:setSpeaker(attacker)
            cutscene:text("* ...")
        end

        cutscene:setSpeaker(enemy)
        cutscene:text("* PHASE THREE.[wait:10]\n* BLACK KNIFE.")
    end,

    noelle_iceshock_followup = function(cutscene, enemy)
        enemy.noelle_iceshock_dialogue_pending = false

        local noelle = cutscene:getCharacter("noelle")
        local defense = math.max(0, enemy.defense or 0)
        local before = math.max(0, enemy.noelle_iceshock_defense_before or defense)

        if noelle then
            noelle.visible = true
            noelle:resetSprite()
            cutscene:shakeCharacter(noelle, 2, 0, 0.85)
            cutscene:setSpeaker(noelle)

            if before <= 0 then
                cutscene:text("* The ice has nothing left to strip away.")
                cutscene:text("* Then I'll aim for the virus itself.")
            elseif defense >= 9 then
                cutscene:text("* It cracked again...[wait:5]\n* Three layers of defense are gone.")
                cutscene:text("* I can do this.[wait:5]\n* I just have to keep my hands steady.")
            elseif defense >= 6 then
                cutscene:text("* The static is thinner now.[wait:5]\n* I can see something moving underneath it.")
                cutscene:text("* You're not untouchable,[wait:5] are you?")
            elseif defense >= 3 then
                cutscene:text("* One layer left...[wait:10]\n* The next IceShock will break it.")
                cutscene:text("* I don't need to feel brave.[wait:5]\n* I only need to cast.")
            else
                cutscene:text("* Its defense is gone.[wait:10]\n* The core is completely exposed.")
                cutscene:text("* The next spell isn't for the shell.")
            end
        end

        cutscene:setSpeaker(enemy)
        if before <= 0 then
            cutscene:text("* DON'T.")
        elseif defense > 6 then
            cutscene:text("* STOP LOOKING AT ME LIKE THAT.")
        elseif defense > 0 then
            cutscene:text("* YOU'RE NOT IN CONTROL.[wait:5]\n* YOU'RE JUST FOLLOWING ORDERS.")
        else
            cutscene:text("* ...[wait:10]\n* TRY IT.")
        end
    end
}
