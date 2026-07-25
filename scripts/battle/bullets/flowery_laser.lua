local FloweryLaser, super = Class(Bullet)

function FloweryLaser:init(x, y, angle, length, warning)
    super.init(self, x, y, "bullets/flowery/laser")
    self:setOrigin(0.5, 0.5)
    self.rotation = angle or 0
    self.length = length or 320
    self.warning_time = warning or 0.7
    self.life = 0
    self.active_time = 0.42
    self.collidable = false
    self.damage = 22
    self.collider = Hitbox(self, -self.length / 2, -5, self.length, 10)
    self.remove_offscreen = false
    self.alpha = 0
end

function FloweryLaser:update()
    self.life = self.life + DT
    if self.life >= self.warning_time then
        if not self.collidable then
            self.collidable = true
            Assets.playSound("snd_flowery_clash_cymbal", 0.55)
        end
        self.alpha = 1
        if self.life >= self.warning_time + self.active_time then
            self:remove()
        end
    end
    super.update(self)
end

function FloweryLaser:draw()
    love.graphics.setLineWidth(self.collidable and 10 or 2)
    if self.collidable then
        love.graphics.setColor(1, 1, 0.4, 0.95)
    else
        local blink = 0.25 + math.abs(math.sin(self.life * 18)) * 0.35
        love.graphics.setColor(1, 0.25, 0.15, blink)
    end
    love.graphics.line(-self.length / 2, 0, self.length / 2, 0)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
end

return FloweryLaser
