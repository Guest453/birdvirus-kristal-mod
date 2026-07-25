local FloweryCrescent, super = Class(Bullet)

function FloweryCrescent:init(x, y, direction, speed, scale)
    super.init(self, x, y, "bullets/flowery/crescent")
    self:setScale(scale or 0.38)
    self:setOrigin(0.5, 0.5)
    self.collider = CircleCollider(self, 0, 0, 13)
    self.damage = 18
    self.physics.direction = direction or 0
    self.physics.speed = speed or 5
    self.physics.spin = 0.12
    self.remove_offscreen = false
end

return FloweryCrescent
