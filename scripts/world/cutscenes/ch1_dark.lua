return {
    wake = function(cutscene)
        if Game:getFlag("ch1_dark_wake_done", false) then
            return
        end

        local player = Game.world.player
        cutscene:detachFollowers()
        Game.world.music:stop()

        if Game:getFlag("birdvirus_leader") == "kris" then
            player:setSprite("world/ch1_dark/extracted/spr_kris_fell/0")
        end
        cutscene:wait(1.6)
        player:shake(2)
        cutscene:wait(0.35)
        player:shake(3)
        cutscene:wait(0.45)
        player:resetSprite()
        cutscene:attachFollowers()
        Game:setFlag("ch1_dark_wake_done", true)
    end,

    wrist_protector = function(cutscene, event)
        cutscene:text("* (You found something shining in the dark.)")
        cutscene:text("* (\"Even in a rush,[wait:5] you need to take care of yourself.\")")
        Assets.playSound("ch1_dark/great_shine")
        cutscene:text("* (You got the Wrist Protector.)\n* (Hold Cancel to skip text.)")
        cutscene:text("* You realized its useless.")
        cutscene:text("* You threw it away. \n* Its cracked in the floor.")

        Game:setFlag("ch1_wrist_protector", true)
        local id = Registry.getItem("wristprotector") and "wristprotector"
            or (Registry.getItem("wrist_protector") and "wrist_protector")
        if id then
            Game.inventory:tryGiveItem(id)
        end
        if event then
            event.visible = true
        end
    end,

    nothing = function(cutscene)
        cutscene:text("* Its cracked in the floor.")
        cutscene:text("* You refuse to pick it up.")
    end,

    susie_town = function(cutscene)
        local susie = cutscene:getCharacter("susie")
        if susie then
            cutscene:setSpeaker(susie)
        end
        if not Game:getFlag("ch1_susie_town_talked", false) then
            cutscene:text("* Oh,[wait:5] you're not dead.[wait:5]\n* Sweet.", "0", "ch1_susie_portrait")
            cutscene:text("* Got any idea what the heck this place is?", "0", "ch1_susie_portrait")
            cutscene:text("* ... me neither.", "0", "ch1_susie_portrait")
            cutscene:text("* Wonder if there's anyone in that building up there...?", "0", "ch1_susie_portrait")
            Game:setFlag("ch1_susie_town_talked", true)
        else
            cutscene:text("* Maybe this place is an abandoned theme park?", "0", "ch1_susie_portrait")
            cutscene:text("* Wait,[wait:5] where are the rides,[wait:5] then...?", "0", "ch1_susie_portrait")
            cutscene:text("* Maybe they abandoned it 'cause there weren't any.", "0", "ch1_susie_portrait")
        end
    end,

    prop_text = function(cutscene, text)
        if type(text) == "table" then
            for _, line in ipairs(text) do
                cutscene:text(line)
            end
        else
            cutscene:text(text)
        end
    end,

    donation_hole = function(cutscene)
        if Game:getFlag("ch1_donation_hole_full", false) then
            cutscene:text("* (The hole is filled to the brim with cash.)")
            return
        end

        cutscene:text('* "Donation Hole"')
        cutscene:text("* (If you like our tutorials,[wait:5] please throw your money into a hole.)")
        local choice = cutscene:choicer({"Throw $1", "Do not"})
        if choice == 1 or choice == "Throw $1" then
            if (Game.money or 0) < 1 then
                cutscene:text("* (You don't have enough money.)")
                cutscene:text("* (You failed to budget enough money to throw into a hole...)")
                return
            end
            Game.money = Game.money - 1
            Game:setFlag("ch1_donation_hole_full", true)
            cutscene:text('* (You put a dollar in the "Hole.")')
            cutscene:text('* (The "Hole" became "Full.")')
        else
            cutscene:text("* (You decided to save the dollar for a different hole.)")
        end
    end,

    candy_tree = function(cutscene)
        if Game:getFlag("ch1_field_candy", false) then
            cutscene:text("* (The candy-shaped fruit has already been taken.)")
            return
        end
        cutscene:text("* (A candy-shaped fruit is hanging from the tree.)")
        local choice = cutscene:choicer({"Take it", "Leave it"})
        if choice ~= 1 and choice ~= "Take it" then
            return
        end
        local item = Registry.getItem("darkcandy") and "darkcandy"
            or (Registry.getItem("dark_candy") and "dark_candy")
        if item and Game.inventory:tryGiveItem(item) then
            Game:setFlag("ch1_field_candy", true)
            cutscene:text("* (You got the Dark Candy.)")
        elseif item then
            cutscene:text("* (You are carrying too much.)")
        else
            Game:setFlag("ch1_field_candy", true)
            cutscene:text("* (You took the candy-shaped fruit.)")
        end
    end,

    field2_lancer = function(cutscene)
        if not Game:getFlag("ch1_field2_lancer_talked", false) then
            cutscene:text("* Ho ho ho...[wait:5] if it isn't my two favorite people.", "0", "ch1_lancer_portrait")
            cutscene:text("* Psyche![wait:5]\n* You guys aren't even in my top five!!", "0", "ch1_lancer_portrait")
            cutscene:text("* Lancer![wait:5]\n* Where's Susie?", "0", "ralsei_hat_ch1")
            cutscene:text("* You mean the purple girl...?", "0", "ch1_lancer_portrait")
            cutscene:text("* She beat me up,[wait:5] so I ran away...!", "0", "ch1_lancer_portrait")
            Game:setFlag("ch1_field2_lancer_talked", true)
        else
            cutscene:text("* Ho ho ho![wait:5]\n* I am still strategically running away!", "0", "ch1_lancer_portrait")
        end
    end,

    scare_lancer = function(cutscene)
        cutscene:text("* Ho ho ho![wait:5]\n* You thought you could sneak past me?", "0", "ch1_lancer_portrait")
        cutscene:text("* Prepare for my newest,[wait:5] least avoidable plan!", "2", "ch1_lancer_portrait")
    end,

    getsusie = function(cutscene, event)
        local susie = cutscene:getCharacter("susie")
        local ralsei = cutscene:getCharacter("ralsei")
        if not ralsei then
            ralsei = Game.world:spawnNPC("ralsei_hat_ch1", 310, 220, {facing = "right"})
        end
        cutscene:detachFollowers()
        if susie and susie ~= Game.world.player then
            susie.visible = false
        end

        if susie then cutscene:setSpeaker(susie) end
        cutscene:text("* Ugh,[wait:5] open up you stupid door!", "2", "ch1_susie_portrait")
        cutscene:text("* Oh,[wait:5] great.[wait:5]\n* It's YOU GUYS.", "0", "ch1_susie_portrait")
        if ralsei then cutscene:setSpeaker(ralsei) end
        cutscene:text("* Susie![wait:5]\n* We were ever so worried about you!", "0", "ralsei_hat_ch1")
        cutscene:text("* ... um,[wait:5] how'd you get past those spikes before?", "1", "ralsei_hat_ch1")
        if susie then cutscene:setSpeaker(susie) end
        cutscene:text("* Walked through 'em.", "0", "ch1_susie_portrait")
        cutscene:text("* But this door...[wait:5]\n* Sucks.", "0", "ch1_susie_portrait")
        if ralsei then cutscene:setSpeaker(ralsei) end
        cutscene:text("* It'll open after we solve the puzzle over there!", "0", "ralsei_hat_ch1")
        if susie then cutscene:setSpeaker(susie) end
        cutscene:text("* Nice.[wait:5]\n* Tell me when you finish it.", "0", "ch1_susie_portrait")
        if ralsei then cutscene:setSpeaker(ralsei) end
        cutscene:text("* Uh,[wait:5] Susie.[wait:5]\n* We need YOU to finish it.", "1", "ralsei_hat_ch1")
        cutscene:text("* Sometimes,[wait:5] proceeding will take all 3 of us.", "0", "ralsei_hat_ch1")
        cutscene:text("* If you don't accompany us,[wait:5] you won't make it home!", "1", "ralsei_hat_ch1")
        if susie then cutscene:setSpeaker(susie) end
        cutscene:text("* So you're saying I HAVE to stick with you guys.", "0", "ch1_susie_portrait")
        if ralsei then cutscene:setSpeaker(ralsei) end
        cutscene:text("* Yep!", "0", "ralsei_hat_ch1")
        if susie then cutscene:setSpeaker(susie) end
        cutscene:text("* Let's just get this over with.", "0", "ch1_susie_portrait")

        -- The source walks Susie down and left. Keep both legs inside this
        -- 640x480 room, then swap cleanly back to the party follower.
        if event then
            cutscene:slideTo(event, 430, 200, 0.55)
            cutscene:slideTo(event, 330, 200, 0.55)
            event.visible = false
        end
        Assets.playSound("item")
        cutscene:text("* Susie joined the party!")
        Game:setFlag("ch1_getsusie_done", true)
        if susie and susie ~= Game.world.player then
            susie.visible = true
        end
        cutscene:alignFollowers()
        cutscene:attachFollowers()
    end,

    room_trigger = function(cutscene, trigger)
        if trigger == "lancer_chase" then
            local susie = cutscene:getCharacter("susie")
            if susie then cutscene:setSpeaker(susie) end
            cutscene:text("* Hey,[wait:5] Kris.\n* There's someone up there waving at us.", "0", "ch1_susie_portrait")
            cutscene:text("* Any idea what they want...?", "0", "ch1_susie_portrait")
            Assets.playSound("ch1_dark/wobbler")
            cutscene:text("* R-run,[wait:5] Kris!", "6", "ch1_susie_portrait")
        elseif trigger == "lancer_slide" then
            local susie = cutscene:getCharacter("susie")
            if susie then cutscene:setSpeaker(susie) end
            cutscene:text("* Kris,[wait:5] down here!", "6", "ch1_susie_portrait")
            Game.world.player:shake(4)
            cutscene:wait(0.5)
        elseif trigger == "dark_landing" then
            Game.world.player:shake(4)
            cutscene:wait(0.4)
            cutscene:text("* You land at the edge of a strange town.")
        elseif trigger == "castle_front" then
            local player = Game.world.player
            local susie = cutscene:getCharacter("susie")
            local ralsei = cutscene:getCharacter("ralsei")

            cutscene:detachFollowers()
            cutscene:detachCamera()
            cutscene:panTo(500, 430, 0.8)
            cutscene:walkTo(player, 460, 560, 0.8, "up")
            if susie and susie ~= player then
                cutscene:walkTo(susie, 520, 590, 0.8, "up")
            end

            cutscene:text("* A castle...?", "0", "ch1_susie_portrait")
            if susie then
                cutscene:setSpeaker(susie)
            end
            cutscene:text("* Why the hell is there a castle inside a supply closet...?", "0", "ch1_susie_portrait")

            -- Ralsei must be a physical character in the courtyard. Looking him
            -- up can return nil when he is not in the selected party, and the
            -- old y=310 spawn was hidden inside the opaque castle facade.
            if not ralsei or ralsei.parent == nil then
                ralsei = Game.world:spawnNPC("ralsei_hat_ch1", 500, 365, {
                    facing = "down",
                    animation = "idle/down",
                })
            else
                ralsei:setPosition(500, 365)
                ralsei.visible = true
                ralsei:setFacing("down")
                ralsei:resetSprite()
            end
            ralsei:setScale(2)
            ralsei:setSprite("idle/down")
            ralsei.visible = true
            ralsei.layer = player.layer + 1
            if ralsei then
                cutscene:setSpeaker(ralsei)
            end
            cutscene:text("* Welcome,[wait:5] heroes...!", "0", ralsei)
            cutscene:text("* Do not be alarmed.[wait:5]\n* I am not your enemy.", "0", ralsei)
            cutscene:text("* Please come forward,[wait:5] both of you...", "0", ralsei)
            cutscene:walkTo(player, 460, 420, 1, "up")
            if susie and susie ~= player then
                cutscene:walkTo(susie, 540, 440, 1, "up")
            end

            cutscene:text("* Once upon a time,[wait:5] a LEGEND was whispered among shadows.", "0", ralsei)
            cutscene:text("* It was a LEGEND of HOPE.[wait:5]\n* It was a LEGEND of DREAMS.", "0", ralsei)
            cutscene:text("* It was a LEGEND of LIGHT.[wait:5]\n* It was a LEGEND of DARK.", "0", ralsei)
            cutscene:text("* This is the legend of DELTA RUNE.", "0", ralsei)
            cutscene:text("* For millennia,[wait:5] LIGHT and DARK have lived in balance.", "0", ralsei)
            cutscene:text("* But if this harmony were to shatter...[wait:5]\n* A terrible calamity would occur.", "1", ralsei)
            cutscene:text("* Only then,[wait:5] shining with hope,[wait:5] three HEROES appear at WORLDS' edge.", "0", ralsei)
            cutscene:text("* A HUMAN.[wait:5]\n* A MONSTER.[wait:5]\n* And a PRINCE FROM THE DARK.", "0", ralsei)
            cutscene:text("* Only they can seal the fountains and banish the ANGEL'S HEAVEN.", "0", ralsei)

            cutscene:text("* Kris,[wait:5] Susie...[wait:5]\n* I deeply believe you two are the HEROES of the LEGEND.", "0", ralsei)
            cutscene:text("* DELTA WARRIORS![wait:5]\n* Please,[wait:5] won't you accept your destiny...?", "0", ralsei)

            if susie then
                cutscene:setSpeaker(susie)
            end
            cutscene:text("* Uhhh...[wait:15]\n* Nah.", "0", "ch1_susie_portrait")
            cutscene:text("* Me?[wait:5]\n* Some kind of hero or something...?", "0", "ch1_susie_portrait")
            cutscene:text("* You've got the wrong person.", "0", "ch1_susie_portrait")
            if ralsei then
                cutscene:setSpeaker(ralsei)
            end
            cutscene:text("* B-but Susie,[wait:5] without you,[wait:5] the world will...", "1", ralsei)
            if susie then
                cutscene:setSpeaker(susie)
            end
            cutscene:text("* So what?[wait:5]\n* If the world gets destroyed,[wait:5] it's none of my damn business.", "2", "ch1_susie_portrait")
            cutscene:text("* Anyway,[wait:5] Kris...[wait:5]\n* If YOU wanna play pretend with this weirdo,[wait:5] stick around.", "0", "ch1_susie_portrait")
            cutscene:text("* I'M going to find a way out of here.", "2", "ch1_susie_portrait")

            -- Keep the mod's selected party intact. Move Susie along the actual
            -- courtyard, then rebuild the follower chain instead of sending her
            -- off-map like the incomplete GameMaker movement port did.
            if susie and susie ~= player then
                cutscene:walkTo(susie, 760, 580, 1.1, "right")
            end
            cutscene:attachCamera()
            cutscene:alignFollowers()
            cutscene:attachFollowers()
        elseif trigger == "tutorial" then
            cutscene:text("* Enemies can be defeated without attacking.", "0", "ralsei_hat_ch1")
            cutscene:text("* ACT,[wait:5] defend,[wait:5] and spare enemies whose names turn yellow.", "0", "ralsei_hat_ch1")
        end
    end,

    glowshard = function(cutscene, event)
        if Game:getFlag("ch1_glowshard", false) then
            cutscene:text("* (It's dark inside.)")
            return
        end

        cutscene:text("* (There's something glowing inside.)")
        local choice = cutscene:choicer({"Yes", "No"})
        if choice ~= 1 and choice ~= "Yes" then
            return
        end

        Game:setFlag("ch1_glowshard", true)
        local id = Registry.getItem("glowshard") and "glowshard"
            or (Registry.getItem("glow_shard") and "glow_shard")
        if id then
            Game.inventory:tryGiveItem(id)
        end
        cutscene:text("* (You got the Glowshard.)")
        if event then
            event.visible = false
        end
    end,
}
