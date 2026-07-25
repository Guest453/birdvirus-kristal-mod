local VirusBoxHunt, super = Class(Wave)

function VirusBoxHunt:init()
    super.init(self)

    self.time = 9
end

function VirusBoxHunt:onStart()
    local enemy = self:getAttackers()[1]
    local arena = Game.battle.arena
    local center_x = (arena.left + arena.right) / 2
    local top_y = arena.top - 24

    if enemy then
        self.enemy = enemy
        self.enemy_start_x = enemy.x
        self.enemy_start_y = enemy.y
        self.timer:tween(0.55, enemy, {x = center_x, y = top_y}, "out-quad")
    end

    self.hunt_count = 0
    self.timer:every(0.78, function()
        local soul = Game.battle.soul
        self.hunt_count = self.hunt_count + 1
        local x = center_x + math.sin(self.hunt_count * 1.15) * 92
        local y = arena.top - 34
        local count = self.hunt_count < 4 and 1 or 2
        for i = 1, count do
            local centered = i - (count + 1) / 2
            self:spawnBullet("virusstab", x + centered * 18, y,
                soul.x + centered * 30, soul.y, 9.5 + self.hunt_count * 0.08, 20)
        end
    end)

    self.timer:every(1.5, function()
        local soul = Game.battle.soul
        local target_x, target_y = soul.x, soul.y
        self:spawnBullet("virusstab", center_x - 54, top_y + 12, target_x, target_y - 24, 13, 20)
        self.timer:after(0.16, function()
            self:spawnBullet("virusstab", center_x + 54, top_y + 12, target_x, target_y + 24, 13, 20)
        end)
    end)
end

function VirusBoxHunt:onEnd(death)
    if self.enemy and not self.enemy:isRemoved() then
        self.enemy:setPosition(self.enemy_start_x, self.enemy_start_y)
    end
    super.onEnd(self, death)
end

function VirusBoxHunt:update()
    super.update(self)
end

return VirusBoxHunt
