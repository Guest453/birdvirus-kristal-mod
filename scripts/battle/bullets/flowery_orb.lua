local FloweryOrb, super = Class(Bullet)

local function turnToward(current, target, amount)
    local difference = (target - current + math.pi) % (math.pi * 2) - math.pi
    return current + math.max(-amount, math.min(amount, difference))
end

function FloweryOrb:init(x, y, direction, speed, variant, homing)
    variant = variant or 0
    local texture = variant == 0 and "bullets/flowery/seed"
        or "bullets/flowery/omega_bullet_"..(((variant - 1) % 9) + 1)
    super.init(self, x, y, texture)

    local inset = math.max(2, math.floor(math.min(self.width, self.height) * 0.2))
    self.collider = Hitbox(self, inset, inset, math.max(2, self.width - inset * 2), math.max(2, self.height - inset * 2))
    self.damage = variant == 0 and 14 or 18
    self.physics.direction = direction or 0
    self.physics.speed = speed or 4
    self.rotation = self.physics.direction
    self.physics.match_rotation = true
    self.homing = homing or 0
    self.remove_offscreen = false
end

function FloweryOrb:update()
    if self.homing > 0 and Game.battle and Game.battle.soul then
        local target = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.direction = turnToward(self.physics.direction, target, self.homing * DTMULT)
    end
    super.update(self)
end

return FloweryOrb
