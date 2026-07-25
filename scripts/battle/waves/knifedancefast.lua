local KnifeDanceFast, super = Class(Wave)

function KnifeDanceFast:init()
    super.init(self)

    self.time = 8
end

function KnifeDanceFast:spawnKnife(angle, delay, speed, lane_offset)
    local soul = Game.battle.soul
    local distance = 82
    lane_offset = lane_offset or 0
    local x = soul.x - math.cos(angle) * distance - math.sin(angle) * lane_offset
    local y = soul.y - math.sin(angle) * distance + math.cos(angle) * lane_offset

    self:spawnBullet("chargedknife", x, y, angle, delay, speed or 11)
end

function KnifeDanceFast:spawnKnifeSet(delay, step_delay, speed)
    local angles = {0, math.rad(180), math.rad(90), math.rad(270), math.rad(45), math.rad(225), math.rad(135), math.rad(315)}

    for i, angle in ipairs(angles) do
        local lane = ((i - 1) % 3 - 1) * 18
        self.timer:after((i - 1) * step_delay, function()
            self:spawnKnife(angle, delay, speed, lane)
        end)
    end
end

function KnifeDanceFast:spawnKnifeGroup(count, delay, step_delay, speed, offset)
    local angles = {0, math.rad(180), math.rad(90), math.rad(270), math.rad(45), math.rad(225), math.rad(135), math.rad(315)}
    offset = offset or 0

    for i = 1, count do
        local angle = angles[((i - 1 + offset) % #angles) + 1]
        local lane = ((i - 1) % 3 - 1) * 18

        self.timer:after((i - 1) * step_delay, function()
            self:spawnKnife(angle, delay, speed, lane)
        end)
    end
end

function KnifeDanceFast:onStart()
    local sets = {
        {time = 0.2, count = 1, charge = 0.86, step = 0.20, speed = 18, offset = 1},
        {time = 1.5, count = 2, charge = 0.70, step = 0.16, speed = 21, offset = 3},
        {time = 2.8, count = 4, charge = 0.56, step = 0.12, speed = 24, offset = 5},
        {time = 4.4, count = 6, charge = 0.42, step = 0.09, speed = 27, offset = 2},
        {time = 6.0, count = 8, charge = 0.30, step = 0.06, speed = 31, offset = 4},
    }

    for _, set in ipairs(sets) do
        self.timer:after(set.time, function()
            self:spawnKnifeGroup(set.count, set.charge, set.step, set.speed, set.offset)
        end)
    end
end

function KnifeDanceFast:update()
    super.update(self)
end

return KnifeDanceFast
