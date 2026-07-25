local VirusCrossExplode, super = Class(Wave)

function VirusCrossExplode:init()
    super.init(self)

    self.time = 9
    self:setArenaSize(300, 190)
end

function VirusCrossExplode:onStart()
    self.cross_count = 0
    self.timer:every(1.1, function()
        local arena = Game.battle.arena
        local soul = Game.battle.soul
        local margin = 48
        local x, y

        self.cross_count = self.cross_count + 1
        if self.cross_count % 2 == 1 then
            x = math.max(arena.left + margin, math.min(arena.right - margin, soul.x))
            y = math.max(arena.top + margin, math.min(arena.bottom - margin, soul.y))
        else
            x = MathUtils.random(arena.left + margin, arena.right - margin)
            y = MathUtils.random(arena.top + margin, arena.bottom - margin)
        end

        self:spawnBullet("explosioncircle", x, y)

        self.timer:after(0.28, function()
            self:spawnBullet("virusstab", arena.left - 20, y, arena.right, y, 10, 20)
            self:spawnBullet("virusstab", arena.right + 20, y, arena.left, y, 10, 20)
            self:spawnBullet("virusstab", x, arena.top - 20, x, arena.bottom, 10, 20)
            self:spawnBullet("virusstab", x, arena.bottom + 20, x, arena.top, 10, 20)
        end)

        if self.cross_count % 3 == 0 then
            self.timer:after(0.58, function()
                local diagonal = 34
                if self.cross_count % 2 == 0 then
                    self:spawnBullet("virusstab", arena.left - 20, arena.top - 20,
                        x + diagonal, y + diagonal, 8.5, 20)
                    self:spawnBullet("virusstab", arena.right + 20, arena.bottom + 20,
                        x - diagonal, y - diagonal, 8.5, 20)
                else
                    self:spawnBullet("virusstab", arena.right + 20, arena.top - 20,
                        x - diagonal, y + diagonal, 8.5, 20)
                    self:spawnBullet("virusstab", arena.left - 20, arena.bottom + 20,
                        x + diagonal, y - diagonal, 8.5, 20)
                end
            end)
        end
    end)
end

function VirusCrossExplode:update()
    super.update(self)
end

return VirusCrossExplode
