local FloweryGMLOrbit, super = Class(Bullet)

function FloweryGMLOrbit:init(x, y, rotation_value, speed)
    super.init(self, x, y, "bullets/flowery/omega_bullet_6")
    self:setOrigin(0.5, 0.5)
    self.collider = CircleCollider(self, 0, 0, 7)
    self.damage = 18
    self.anchor_x = x
    self.anchor_y = y
    self.rotation_value = rotation_value or 0
    self.orbit_distance = 34
    self.scroll_speed = speed or 5.2
    self.timer = 0
    self.remove_offscreen = false
end

function FloweryGMLOrbit:update()
    self.timer = self.timer + DTMULT
    self.anchor_x = self.anchor_x - self.scroll_speed * DTMULT
    local angle = self.rotation_value + self.timer * 0.07
    self.x = self.anchor_x + math.cos(angle) * self.orbit_distance
    self.y = self.anchor_y + math.sin(angle) * self.orbit_distance
    self.rotation = angle
    if self.anchor_x < Game.battle.arena.left - 60 then
        self:remove()
    end
    super.update(self)
end

return FloweryGMLOrbit
