local VirusShot, super = Class(Bullet)

function VirusShot:init(x, y, target_x, target_y, speed)
    super.init(self, x, y, "bullets/smallbullet")

    self.damage = 1
    self.can_graze = false
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self.collider = CircleCollider(self, 0, 0, 4)
    self:setScale(0.75)
    self.physics.direction = MathUtils.angle(x, y, target_x, target_y)
    self.physics.speed = speed or 13
end

function VirusShot:draw()
    Draw.setColor(1, 0.95, 0.25, 1)
    love.graphics.circle("fill", 0, 0, 5)
    Draw.setColor(1, 0.2, 0.05, 1)
    love.graphics.circle("line", 0, 0, 5)
    Draw.setColor(1, 1, 1, 1)

    super.draw(self)
end

return VirusShot
