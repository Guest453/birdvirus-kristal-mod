local KnifeDance, super = Class(Wave)

function KnifeDance:init()
    super.init(self)

    self.time = 8
end

function KnifeDance:spawnKnife(angle, delay, speed, lane_offset)
    local soul = Game.battle.soul
    local distance = 78
    lane_offset = lane_offset or 0
    local x = soul.x - math.cos(angle) * distance - math.sin(angle) * lane_offset
    local y = soul.y - math.sin(angle) * distance + math.cos(angle) * lane_offset
    self:spawnBullet("chargedknife", x, y, angle, delay, speed or 8.5)
end

function KnifeDance:spawnKnifeSet(delay, step_delay, speed)
    local angles = {
        0,
        math.rad(90),
        math.rad(180),
        math.rad(270),
        math.rad(45),
        math.rad(135),
        math.rad(225),
        math.rad(315),
    }

    for i, angle in ipairs(angles) do
        local lane = ((i - 1) % 3 - 1) * 16
        self.timer:after((i - 1) * step_delay, function()
            self:spawnKnife(angle, delay, speed, lane)
        end)
    end
end

function KnifeDance:spawnKnifeGroup(count, delay, step_delay, speed, offset)
    local angles = {0, math.rad(180), math.rad(90), math.rad(270), math.rad(45), math.rad(225), math.rad(135), math.rad(315)}
    offset = offset or 0

    for i = 1, count do
        local angle = angles[((i - 1 + offset) % #angles) + 1]
        local lane = ((i - 1) % 3 - 1) * 16

        self.timer:after((i - 1) * step_delay, function()
            self:spawnKnife(angle, delay, speed, lane)
        end)
    end
end

function KnifeDance:onStart()
    local sets = {
        {time = 0.2, count = 1, charge = 1.00, step = 0.26, speed = 16, offset = 0},
        {time = 1.6, count = 2, charge = 0.84, step = 0.22, speed = 18, offset = 2},
        {time = 3.0, count = 3, charge = 0.70, step = 0.18, speed = 20, offset = 4},
        {time = 4.6, count = 5, charge = 0.55, step = 0.14, speed = 23, offset = 1},
        {time = 6.2, count = 7, charge = 0.40, step = 0.09, speed = 26, offset = 3},
    }

    for _, set in ipairs(sets) do
        self.timer:after(set.time, function()
            self:spawnKnifeGroup(set.count, set.charge, set.step, set.speed, set.offset)
        end)
    end
end

function KnifeDance:update()
    super.update(self)
end

return KnifeDance
