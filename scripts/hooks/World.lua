local World, super = HookSystem.hookScript(World)

function World:loadMap(...)
    super.loadMap(self, ...)

    if Game:getFlag("birdvirus_leader") == "ralsei" and self.player then
        self.player:setActor("ralsei_hat_ch1")
    end

    if self.map and self.map.id == "room_dark1" and not Game:getFlag("birdvirus_party_selected", false) then
        self.timer:after(0.1, function()
            if Game.world == self and not self:hasCutscene() then
                self:startCutscene("room1", "choose_party")
            end
        end)
    elseif self.map and self.map.id == "room_dark1" and not Game:getFlag("ch1_dark_wake_done", false) then
        self.timer:after(0.1, function()
            if Game.world == self and not self:hasCutscene() then
                self:startCutscene("ch1_dark", "wake")
            end
        end)
    end
end

return World
