local CornerKnives, super = Class(Wave)

function CornerKnives:init()
    super.init(self)

    self.time = 8
end

function CornerKnives:onStart()
    local arena = Game.battle.arena
    local anchors = {
        {x = arena.left + 22, y = arena.top + 22, angle = math.rad(225)},
        {x = arena.right - 22, y = arena.top + 22, angle = math.rad(315)},
        {x = arena.left + 22, y = arena.bottom - 22, angle = math.rad(135)},
        {x = arena.right - 22, y = arena.bottom - 22, angle = math.rad(45)},
        {x = arena.left + 22, y = (arena.top + arena.bottom) / 2, angle = math.rad(180)},
        {x = arena.right - 22, y = (arena.top + arena.bottom) / 2, angle = 0},
        {x = (arena.left + arena.right) / 2, y = arena.top + 22, angle = math.rad(270)},
        {x = (arena.left + arena.right) / 2, y = arena.bottom - 22, angle = math.rad(90)},
    }

    local function spawnVolley(start_time, indices, orbit_time, aim_pause, speed, step)
        for order, index in ipairs(indices) do
            self.timer:after(start_time + (order - 1) * step, function()
                local anchor = anchors[index]
                local spin = (index % 2 == 0) and 0.045 or -0.045
                self:spawnBullet("cornerknife", anchor.x, anchor.y, anchor.angle, 26, spin,
                    orbit_time, speed, aim_pause)
            end)
        end
    end

    -- Teach the attack with one blade, then escalate through three increasingly dense volleys.
    spawnVolley(0.15, {1},                0.95, 0.65, 22, 0.12)
    spawnVolley(1.65, {2, 3, 4},          0.90, 0.55, 24, 0.16)
    spawnVolley(3.65, {5, 6, 7, 8},       0.78, 0.48, 26, 0.13)
    spawnVolley(5.65, {1, 5, 2, 7, 4, 6}, 0.62, 0.38, 29, 0.10)
end

function CornerKnives:update()
    super.update(self)
end

return CornerKnives
