return {
    choose_party = function(cutscene)
        cutscene:text("* Choose who leads.")
        local choice = cutscene:choicer({"Kris", "Ralsei", "Noelle"})
        local leader = "kris"

        if choice == 2 or choice == "Ralsei" then
            leader = "ralsei"
        elseif choice == 3 or choice == "Noelle" then
            leader = "noelle"
        end

        Game:setFlag("birdvirus_party_selected", true)
        Game:setFlag("birdvirus_leader", leader)

        if leader == "noelle" then
            local noelle = Game:getPartyMember("noelle")
            if noelle then
                if Registry.getSpell("iceshock") and not noelle:hasSpell("iceshock") then
                    noelle:addSpell("iceshock")
                elseif Registry.getSpell("ice_shock") and not noelle:hasSpell("ice_shock") then
                    noelle:addSpell("ice_shock")
                end
            end
        end

        Game:setPartyMembers(leader, "susie")

        for _, follower in ipairs(Game.world.followers) do
            follower:remove()
        end
        Game.world.followers = {}
        Game.temp_followers = {}
        Game.world:spawnParty("spawn", Game.party)
        Game.world:attachFollowersImmediate()

        if leader == "ralsei" and Game.world.player then
            Game.world.player:setActor("ralsei_hat_ch1")
        end

        if leader == "kris" then
            cutscene:text("* Kris steps forward.")
        elseif leader == "ralsei" then
            cutscene:text("* Ralsei steps forward.")
        else
            cutscene:text("* Noelle steps forward.[wait:5]\n* The air feels colder.")
        end

        if Game.world.map and Game.world.map.id == "room_dark1" and not Game:getFlag("ch1_dark_wake_done", false) then
            Game.world.timer:after(0.1, function()
                if Game.world and not Game.world:hasCutscene() then
                    Game.world:startCutscene("ch1_dark", "wake")
                end
            end)
        end
    end,

    wall = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* The wall seems cracked.")

        -- If we have Susie, play a cutscene
        local susie = cutscene:getCharacter("susie")
        if susie then
            -- Detach camera and followers (since characters will be moved)
            cutscene:detachCamera()
            cutscene:detachFollowers()

            -- All text from now is spoken by Susie
            cutscene:setSpeaker(susie)
            cutscene:text("* Hey,[wait:5] think I can break\nthis wall?", "smile")

            -- Get the bottom-center of the broken wall
            local x = event.x + event.width/2
            local y = event.y + event.height/2

            -- Move Susie up to the wall over 0.75 seconds
            cutscene:walkTo(susie, x, y + 40, 0.75, "up")
            -- Move other party members behind Susie
            cutscene:walkTo(Game.world.player, x, y + 100, 0.75, "up")
            if cutscene:getCharacter("ralsei") then
                cutscene:walkTo("ralsei", x + 60, y + 100, 0.75, "up")
            end
            if cutscene:getCharacter("noelle") then
                cutscene:walkTo("noelle", x - 60, y + 100, 0.75, "up")
            end

            -- Wait 1.5 seconds
            cutscene:wait(1.5)

            -- Walk back,
            cutscene:wait(cutscene:walkTo(susie, x, y + 60, 0.5, "up", true))
            -- and run forward!
            cutscene:wait(cutscene:walkTo(susie, x, y + 20, 0.2))

            -- Slam!!
            Assets.playSound("impact")
            susie:shake(4)
            susie:setSprite("shock_up")

            -- Slide back a bit
            cutscene:slideTo(susie, x, y + 40, 0.1)
            cutscene:wait(1.5)

            -- owie
            susie:setAnimation({"away_scratch", 0.25, true})
            susie:shake(4)
            Assets.playSound("wing")

            cutscene:wait(1)
            cutscene:text("* Guess not.", "nervous")

            -- Reset Susie's sprite
            susie:resetSprite()

            -- Reattach the camera
            cutscene:attachCamera()

            -- Align the follower positions behind Kris's current position
            cutscene:alignFollowers()
            -- And reattach them, making them return to their target positions
            cutscene:attachFollowers()
            Game:setFlag("wall_hit", true)
        end
    end
}
