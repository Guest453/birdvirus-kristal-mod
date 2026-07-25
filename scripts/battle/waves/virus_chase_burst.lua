local VirusChaseBurst, super = Class(Wave)

function VirusChaseBurst:init()
    super.init(self)

    self.time = 9
end

function VirusChaseBurst:onStart()
    self.burst_count = 0
    self.chase_count = 0

    self.timer:every(0.90, function()
        local soul = Game.battle.soul
        self.chase_count = self.chase_count + 1
        local angle = love.math.random() * math.pi * 2
        local radius = 150
        local count = self.chase_count >= 3 and self.chase_count % 2 == 0 and 2 or 1
        for i = 1, count do
            local side = i == 1 and -1 or 1
            local spawn_angle = angle + (count == 2 and side * 0.34 or 0)
            local x = soul.x + math.cos(spawn_angle) * radius
            local y = soul.y + math.sin(spawn_angle) * radius
            local perpendicular_x = -math.sin(angle) * side * 24
            local perpendicular_y = math.cos(angle) * side * 24
            self:spawnBullet("virusstab", x, y, soul.x + perpendicular_x,
                soul.y + perpendicular_y, 11.5, 20)
        end
    end)

    self.timer:every(1.45, function()
        local arena = Game.battle.arena
        local from_left = self.burst_count % 2 == 0
        local gap = (self.burst_count % 4) + 1
        local start_x = from_left and arena.left - 20 or arena.right + 20
        local target_x = from_left and arena.right or arena.left

        for lane = 1, 5 do
            if lane ~= gap and lane ~= gap + 1 then
                local y = arena.top + lane * arena.height / 6
                self.timer:after((lane - 1) * 0.06, function()
                    self:spawnBullet("virusshot", start_x, y, target_x, y, 13.5)
                end)
            end
        end

        -- A delayed return sweep uses the same opening from the opposite edge.
        self.timer:after(0.34, function()
            local return_x = from_left and arena.right + 20 or arena.left - 20
            local return_target = from_left and arena.left or arena.right
            for lane = 1, 5 do
                if lane ~= gap and lane ~= gap + 1 and lane % 2 == self.burst_count % 2 then
                    local y = arena.top + lane * arena.height / 6
                    self:spawnBullet("virusshot", return_x, y, return_target, y, 12.5)
                end
            end
        end)

        self.burst_count = self.burst_count + 1
    end)
end

function VirusChaseBurst:update()
    super.update(self)
end

return VirusChaseBurst
