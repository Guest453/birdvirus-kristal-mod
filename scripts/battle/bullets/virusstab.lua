local VirusStab, super = Class(Bullet)

function VirusStab:init(x, y, target_x, target_y, speed, damage)
    super.init(self, x, y, "bullets/smallbullet")

    if self.sprite then
        self.sprite.visible = false
    end

    self.damage = damage or 20
    self.can_graze = true
    self.destroy_on_hit = false
    self.remove_offscreen = false
    self.collider = CircleCollider(self, 0, 0, 10)
    self.physics.direction = MathUtils.angle(x, y, target_x, target_y)
    self.dash_speed = speed or 8
    self.physics.speed = 0
    self.rotation = self.physics.direction
    self.charge_time = 0.34
    self.charge_timer = 0
    self.collidable = false
end

function VirusStab:getDamage()
    local damage = super.getDamage(self)
    if self.attacker and self.attacker.scaleDamage then
        return self.attacker:scaleDamage(damage)
    end
    return damage
end

function VirusStab:update()
    if self.charge_timer < self.charge_time then
        self.charge_timer = self.charge_timer + DT
        if self.charge_timer >= self.charge_time then
            self.collidable = true
            self.physics.speed = self.dash_speed
        end
    end

    super.update(self)
end

function VirusStab:draw()
    if self.charge_timer < self.charge_time then
        local progress = math.min(1, self.charge_timer / self.charge_time)
        local alpha = 0.16 + progress * 0.34
        love.graphics.setLineWidth(2)
        Draw.setColor(1, 0.15, 0.15, alpha)
        love.graphics.line(0, 0, 620, 0)
    end

    love.graphics.setLineWidth(5)
    Draw.setColor(1, 0.1, 0.1, 1)
    love.graphics.line(-18, 0, 22, 0)
    Draw.setColor(1, 0.75, 0.75, 1)
    love.graphics.line(6, -8, 22, 0, 6, 8)
    love.graphics.setLineWidth(1)
    Draw.setColor(1, 1, 1, 1)

    super.draw(self)
end

return VirusStab
