local Ch1Shine, super = Class(Event, "ch1_shine")

function Ch1Shine:init(data)
    super.init(self, data.x, data.y, data.width or 40, data.height or 40, data)
    self.textures = {}
    for i = 0, 3 do
        self.textures[i + 1] = Assets.getTexture("world/ch1_dark/extracted/spr_shine/" .. i)
    end
    self.frame = 0
    self.frame_timer = 0
    self.solid = false
    if Game:getFlag("ch1_wrist_protector", false) then
        self.visible = false
    end
end

function Ch1Shine:update()
    self.frame_timer = self.frame_timer + DT
    if self.frame_timer >= 0.12 then
        self.frame_timer = self.frame_timer - 0.12
        self.frame = (self.frame + 1) % #self.textures
    end
    super.update(self)
end

function Ch1Shine:draw()
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.textures[self.frame + 1], 0, 0, 0, 2, 2)
    love.graphics.setColor(1, 1, 1, 1)
    super.draw(self)
end

function Ch1Shine:onInteract()
    if Game:getFlag("ch1_wrist_protector", false) then
        Game.world:startCutscene("ch1_dark", "nothing")
    else
        Game.world:startCutscene("ch1_dark", "wrist_protector", self)
    end
    return true
end

return Ch1Shine
