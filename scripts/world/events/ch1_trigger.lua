local Ch1Trigger, super = Class(Event, "ch1_trigger")

function Ch1Trigger:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 40, data.height or 40, data)
    self.trigger = props.trigger
    self.flag = props.flag or ("ch1_trigger_" .. tostring(self.trigger))
    self.auto = props.auto or false
    self.solid = false
    self.visible = false
end

function Ch1Trigger:update()
    local player = Game.world and Game.world.player
    if player and not Game:getFlag(self.flag, false) and not Game.world:hasCutscene() then
        local px, py = player.x, player.y
        if self.auto or (px >= self.x and px <= self.x + self.width
            and py >= self.y and py <= self.y + self.height) then
            Game:setFlag(self.flag, true)
            Game.world:startCutscene("ch1_dark", "room_trigger", self.trigger)
        end
    end
    super.update(self)
end

return Ch1Trigger
