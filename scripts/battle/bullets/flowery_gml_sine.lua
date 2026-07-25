local FloweryGMLSine, super = Class(Bullet)

function FloweryGMLSine:init(x, center_y, phase, lower)
    super.init(self, x, center_y, "bullets/flowery/omega_bullet_4")
    self:setOrigin(0.5, 0.5)
    self:setScale(0.85)
    self.collider = CircleCollider(self, 0, 0, 7)
    self.damage = 18
    self.center_y = center_y
    self.phase = phase or 0
    self.lower = lower
    self.timer = 0
    self.physics.direction = math.pi
    self.physics.speed = 2.35
    self.physics.spin = 0.07
    self.remove_offscreen = false
end

function FloweryGMLSine:update()
    self.timer = self.timer + DTMULT
    local amplitude = 48
    local wave = math.sin(self.phase + self.timer * 0.055) * amplitude
    self.y = self.center_y + (self.lower and 58 or -58) + wave
    super.update(self)
end

return FloweryGMLSine
