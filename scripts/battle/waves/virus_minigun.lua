local VirusMinigun, super = Class(Wave)

function VirusMinigun:init()
    super.init(self)

    self.time = 9
    self.attack_clock = 0
    self.shot_count = 0
    self.firing = false
end

function VirusMinigun:onStart()
    local enemy = self:getAttackers()[1]
    local arena = Game.battle.arena
    local gun_x = arena.left + 28
    local gun_y = arena.top - 32

    if enemy then
        self.enemy = enemy
        self.enemy_start_x = enemy.x
        self.enemy_start_y = enemy.y
        self.timer:tween(0.5, enemy, {x = gun_x, y = gun_y}, "out-quad")
    end

    self.timer:every(0.065, function()
        local cycle = self.attack_clock % 1.35
        self.firing = cycle >= 0.35 and cycle <= 0.95
        if not self.firing then
            return
        end

        local soul = Game.battle.soul
        local sweep = math.sin(self.shot_count * 0.72) * 26
        local jitter = MathUtils.random(-7, 7)
        self:spawnBullet("virusshot", gun_x + 24, gun_y + 8,
            soul.x + sweep, soul.y + jitter, MathUtils.random(12, 16))
        if self.shot_count > 0 and self.shot_count % 6 == 0 then
            self:spawnBullet("virusshot", gun_x + 24, gun_y + 14,
                soul.x - sweep * 0.65, soul.y - jitter, MathUtils.random(11, 14))
        end
        self.shot_count = self.shot_count + 1
    end)
end

function VirusMinigun:onEnd(death)
    if self.enemy and not self.enemy:isRemoved() then
        self.enemy:setPosition(self.enemy_start_x, self.enemy_start_y)
    end
    super.onEnd(self, death)
end

function VirusMinigun:draw()
    if self.enemy then
        local flash = self.firing and (0.55 + math.abs(math.sin(self.attack_clock * 45)) * 0.45) or 0.2
        Draw.setColor(0.1, 0.1, 0.1, 1)
        love.graphics.rectangle("fill", self.enemy.x - 2, self.enemy.y + 8, 50, 12)
        Draw.setColor(1, 0.35 + flash * 0.4, 0.15, 1)
        love.graphics.rectangle("line", self.enemy.x - 2, self.enemy.y + 8, 50, 12)
        if not self.firing and Game.battle.soul then
            Draw.setColor(1, 0.15, 0.1, 0.22)
            love.graphics.line(self.enemy.x + 48, self.enemy.y + 14,
                Game.battle.soul.x, Game.battle.soul.y)
        end
        Draw.setColor(1, 1, 1, 1)
    end

    super.draw(self)
end

function VirusMinigun:update()
    self.attack_clock = self.attack_clock + DT
    super.update(self)
end

return VirusMinigun
