local GiantBombBullet, super = Class(Bullet)

function GiantBombBullet:init(x, y)
    super.init(self, x, y, "bullets/smallbullet")

    if self.sprite then
        self.sprite.visible = false
    end

    self.life = 0
    self.fall_time = 4.8
    self.explosion_time = 1.6
    self.start_y = y
    self.target_y = SCREEN_HEIGHT / 2
    self.radius = 42
    self.exploded = false
    self.damage = 1
    self.can_graze = false
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self.collider = nil
end

function GiantBombBullet:onDamage(soul)
    local battlers = Game.battle:hurt(self.damage, true, self:getTarget(), self:shouldSwoon(self.damage, self:getTarget(), soul))

    soul.inv_timer = self:getInvulnTime()
    soul:onDamage(self, self.damage)

    return battlers
end

function GiantBombBullet:spawnScreenExplosion()
    local positions = {
        {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 5},
        {SCREEN_WIDTH * 0.25, SCREEN_HEIGHT * 0.25, 4},
        {SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.25, 4},
        {SCREEN_WIDTH * 0.25, SCREEN_HEIGHT * 0.75, 4},
        {SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.75, 4},
    }

    Assets.playSound("explosion_firework")

    for _, data in ipairs(positions) do
        local explosion = Explosion(data[1], data[2])
        explosion.layer = BATTLE_LAYERS["above_arena"] or 1000
        explosion:setScale(data[3])
        Game.battle:addChild(explosion)
    end

    Game.battle:shakeCamera(12, 12, 0.9)
end

function GiantBombBullet:update()
    self.life = self.life + DT

    if self.life < self.fall_time then
        local progress = self.life / self.fall_time
        local eased = progress * progress

        self.y = self.start_y + ((self.target_y - self.start_y) * eased)
        self.radius = 42 + (math.sin(self.life * 8) * 3)
        self.collider = nil
    elseif self.life < self.fall_time + self.explosion_time then
        local progress = (self.life - self.fall_time) / self.explosion_time

        if not self.exploded then
            self.exploded = true
            self:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
            self:spawnScreenExplosion()
        end

        self.radius = 120 + (520 * progress)

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

function GiantBombBullet:draw()
    if self.life < self.fall_time then
        local pulse = 0.7 + (math.abs(math.sin(self.life * 10)) * 0.3)
        local warning = math.min(1, self.life / self.fall_time)

        Draw.setColor(0.05, 0.05, 0.05, 1)
        love.graphics.circle("fill", 0, 0, self.radius)
        Draw.setColor(1, 0.15, 0.05, pulse)
        love.graphics.setLineWidth(4)
        love.graphics.circle("line", 0, 0, self.radius + 4)
        Draw.setColor(1, 0.8, 0.2, pulse)
        love.graphics.line(0, -self.radius, 16, -self.radius - 24)
        Draw.setColor(1, 0.2, 0.05, 0.25 + warning * 0.45)
        love.graphics.circle("line", 0, 0, self.radius + 15 + math.sin(self.life * 7) * 5)
        love.graphics.line(-self.radius - 26, 0, self.radius + 26, 0)
        love.graphics.line(0, -self.radius - 26, 0, self.radius + 26)
    else
        local progress = (self.life - self.fall_time) / self.explosion_time
        local alpha = 1 - progress

        Draw.setColor(1, 0.85, 0.15, 0.5 * alpha)
        love.graphics.circle("fill", 0, 0, self.radius)
        Draw.setColor(1, 1, 1, alpha)
        love.graphics.setLineWidth(8)
        love.graphics.circle("line", 0, 0, self.radius)
    end

    love.graphics.setLineWidth(1)
    Draw.setColor(1, 1, 1, 1)

    super.draw(self)
end

return GiantBombBullet
