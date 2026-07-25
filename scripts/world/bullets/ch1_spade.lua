local Ch1Spade, super = Class(WorldBullet, "ch1_spade")

function Ch1Spade:init(x, y, direction, speed)
    super.init(self, x, y, "world/ch1_dark/extracted/spr_spadebullet/0")
    self.direction = direction or math.pi
    self.speed = speed or 260
    self.rotation = self.direction
    self.damage = 12
    self.collider = Hitbox(self, 8, 7, 20, 20)
end

function Ch1Spade:update()
    self.x = self.x + math.cos(self.direction) * self.speed * DT
    self.y = self.y + math.sin(self.direction) * self.speed * DT
    super.update(self)
end

return Ch1Spade
