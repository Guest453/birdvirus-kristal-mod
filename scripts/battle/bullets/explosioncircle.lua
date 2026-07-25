local ExplosionCircle, super = Class(Bullet)

function ExplosionCircle:init(x, y)
    super.init(self, x, y, "bullets/smallbullet")

    self:setScale(1, 1)
    if self.sprite then
        self.sprite.visible = false
    end

    self.life = 0
    self.warning_time = 0.8
    self.explosion_time = 0.45
    self.radius = 14
    self.max_radius = 58
    self.damage = 100
    self.exploded = false
    self.can_graze = false
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self.collider = nil
end

function ExplosionCircle:onDamage(soul)
    local damage = self:getDamage()
    local battlers = Game.battle:hurt(damage, true, self:getTarget(), self:shouldSwoon(damage, self:getTarget(), soul))

    soul.inv_timer = self:getInvulnTime()
    soul:onDamage(self, damage)

    return battlers
end

function ExplosionCircle:getDamage()
    local damage = super.getDamage(self)

    if self.attacker and self.attacker.scaleDamage then
        return self.attacker:scaleDamage(damage)
    end

    return damage
end

function ExplosionCircle:update()
    self.life = self.life + DT

    if self.life < self.warning_time then
        local progress = self.life / self.warning_time

        -- The warning ring shows the exact final danger radius before it becomes harmful.
        self.radius = 14 + ((self.max_radius - 14) * progress)
        self.collider = nil
    elseif self.life < self.warning_time + self.explosion_time then
        local progress = (self.life - self.warning_time) / self.explosion_time

        if not self.exploded then
            self.exploded = true
            Assets.playSound("explosion_firework")
            local explosion = Explosion(self.x, self.y)
            explosion.layer = BATTLE_LAYERS["above_arena"] or 1000
            Game.battle:addChild(explosion)
        end

        self.radius = 18 + ((self.max_radius - 18) * math.min(progress * 2, 1))

        if self.collider then
            self.collider.radius = self.radius
        else
            self.collider = CircleCollider(self, 0, 0, self.radius)
        end
    else
        self:remove()
    end

    super.update(self)
end

function ExplosionCircle:draw()
    local warning = self.life < self.warning_time
    local flicker = 0.35 + (math.abs(math.sin(self.life * 34)) * 0.45)

    love.graphics.setLineWidth(3)

    if warning then
        Draw.setColor(1, 0.9, 0.2, flicker)
        love.graphics.circle("line", 0, 0, self.radius)
        Draw.setColor(1, 0.3, 0.05, flicker * 0.7)
        love.graphics.circle("line", 0, 0, self.radius * 0.65)
        love.graphics.line(-self.radius - 8, 0, self.radius + 8, 0)
        love.graphics.line(0, -self.radius - 8, 0, self.radius + 8)
    else
        local progress = (self.life - self.warning_time) / self.explosion_time
        local alpha = 1 - progress

        Draw.setColor(1, 0.2, 0.05, alpha)
        love.graphics.circle("line", 0, 0, self.radius)
    end

    love.graphics.setLineWidth(1)
    Draw.setColor(1, 1, 1, 1)

    super.draw(self)
end

return ExplosionCircle
