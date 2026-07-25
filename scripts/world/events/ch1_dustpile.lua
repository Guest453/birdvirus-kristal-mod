local Ch1Dustpile, super = Class(Event, "ch1_dustpile")

function Ch1Dustpile:init(data)
    super.init(self, data.x, data.y, data.width or 126, data.height or 92, data)
    self.texture = Assets.getTexture("world/ch1_dark/extracted/spr_dustpile/0")
    self.flag = "ch1_dust_" .. tostring(data.id)
    self.broken = Game:getFlag(self.flag, false)
    self.breaking = false
    self.solid = not self.broken
    if self.broken then
        self.visible = false
    end
end

function Ch1Dustpile:onInteract()
    if self.broken then
        return false
    end

    self.broken = true
    self.breaking = true
    self.solid = false
    Game:setFlag(self.flag, true)
    Assets.playSound("ch1_dark/cough")
    self:shake(6)
    return true
end

function Ch1Dustpile:update()
    if self.breaking then
        self.alpha = self.alpha - DT / 0.35
        if self.alpha <= 0 then
            self:remove()
            return
        end
    end
    super.update(self)
end

function Ch1Dustpile:draw()
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.texture, 0, 0, 0, 2, 2)
    love.graphics.setColor(1, 1, 1, 1)
    super.draw(self)
end

return Ch1Dustpile
