local Ch1Glowshard, super = Class(Event, "ch1_glowshard")

function Ch1Glowshard:init(data)
    super.init(self, data.x, data.y, data.width or 40, data.height or 60, data)
    self.solid = false
    if Game:getFlag("ch1_glowshard", false) then
        self.visible = false
    end
end

function Ch1Glowshard:onInteract()
    Game.world:startCutscene("ch1_dark", "glowshard", self)
    return true
end

return Ch1Glowshard
