local VirusExplosions, super = Class(Wave)

function VirusExplosions:init()
    super.init(self)

    self.time = 8
    self:setArenaSize(300, 190)
end

function VirusExplosions:onStart()
    self.spawn_count = 0
    self.last_x = nil
    self.last_y = nil

    local function spawnExplosion()
        local arena = Game.battle.arena
        local soul = Game.battle.soul
        local margin = 55
        local x, y

        self.spawn_count = self.spawn_count + 1
        if self.spawn_count % 3 == 1 then
            -- An occasional soul-targeted blast forces movement, but its full radius is telegraphed.
            x = math.max(arena.left + margin, math.min(arena.right - margin, soul.x))
            y = math.max(arena.top + margin, math.min(arena.bottom - margin, soul.y))
        else
            -- Re-roll away from the last blast so warning circles do not form unavoidable stacks.
            for _ = 1, 10 do
                local candidate_x = MathUtils.random(arena.left + margin, arena.right - margin)
                local candidate_y = MathUtils.random(arena.top + margin, arena.bottom - margin)
                x, y = candidate_x, candidate_y
                local dx = self.last_x and candidate_x - self.last_x or 999
                local dy = self.last_y and candidate_y - self.last_y or 999
                if math.sqrt(dx * dx + dy * dy) >= 88 then
                    break
                end
            end
        end

        self:spawnBullet("explosioncircle", x, y)
        self.last_x, self.last_y = x, y
    end

    self.timer:after(0.25, spawnExplosion)
    self.timer:every(0.72, spawnExplosion)
end

function VirusExplosions:update()
    super.update(self)
end

return VirusExplosions
