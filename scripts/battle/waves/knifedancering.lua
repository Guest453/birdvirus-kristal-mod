local KnifeDanceRing, super = Class(Wave)

local function scaleDamage(wave, amount)
    local attacker = wave:getAttackers()[1]

    if attacker and attacker.scaleDamage then
        return attacker:scaleDamage(amount)
    end

    return amount
end

function KnifeDanceRing:init()
    super.init(self)

    self.time = 8
    self.ring_blades = {}
    self.ring_timer = 0
end

function KnifeDanceRing:spawnKnife(angle, delay, speed, lane_offset)
    local soul = Game.battle.soul
    local distance = 78
    lane_offset = lane_offset or 0
    local x = soul.x - math.cos(angle) * distance - math.sin(angle) * lane_offset
    local y = soul.y - math.sin(angle) * distance + math.cos(angle) * lane_offset

    self:spawnBullet("chargedknife", x, y, angle, delay, speed or 9)
end

function KnifeDanceRing:spawnKnifeSet(delay, step_delay, speed)
    local angles = {0, math.rad(90), math.rad(180), math.rad(270), math.rad(45), math.rad(135), math.rad(225), math.rad(315)}

    for i, angle in ipairs(angles) do
        local lane = ((i - 1) % 3 - 1) * 17
        self.timer:after((i - 1) * step_delay, function()
            self:spawnKnife(angle, delay, speed, lane)
        end)
    end
end

function KnifeDanceRing:spawnKnifeGroup(count, delay, step_delay, speed, offset)
    local angles = {0, math.rad(180), math.rad(90), math.rad(270), math.rad(45), math.rad(225), math.rad(135), math.rad(315)}
    offset = offset or 0

    for i = 1, count do
        local angle = angles[((i - 1 + offset) % #angles) + 1]
        local lane = ((i - 1) % 3 - 1) * 17

        self.timer:after((i - 1) * step_delay, function()
            self:spawnKnife(angle, delay, speed, lane)
        end)
    end
end

function KnifeDanceRing:startRing()
    local arena = Game.battle.arena
    local center_x = (arena.left + arena.right) / 2
    local center_y = (arena.top + arena.bottom) / 2

    -- Six blades leave generous moving gaps and arm only after their orbit is visible.
    for i = 1, 6 do
        local angle = ((i - 1) / 6) * math.pi * 2
        local bullet = self:spawnBullet("bullets/birdvirusSWORD", center_x + math.cos(angle) * 82, center_y + math.sin(angle) * 82)

        bullet:setOriginExact(34, 31)
        bullet.collider = Hitbox(bullet, 10, 14, 49, 34)
        bullet.damage = scaleDamage(self, 14) + (self.snowgrave_damage_bonus or 0)
        bullet.collidable = false
        bullet.physics.speed = 0
        bullet.rotation = angle + math.pi
        bullet.ring_angle = angle
        bullet.remove_offscreen = false
        bullet:setScale(0.75)
        table.insert(self.ring_blades, bullet)
    end
end

function KnifeDanceRing:onStart()
    self:startRing()

    local sets = {
        {time = 0.5, count = 1, charge = 0.95, step = 0.26, speed = 17, offset = 0},
        {time = 1.8, count = 2, charge = 0.82, step = 0.21, speed = 19, offset = 2},
        {time = 3.3, count = 3, charge = 0.66, step = 0.17, speed = 21, offset = 4},
        {time = 4.8, count = 5, charge = 0.50, step = 0.13, speed = 24, offset = 1},
        {time = 6.3, count = 7, charge = 0.36, step = 0.08, speed = 27, offset = 3},
    }

    for _, set in ipairs(sets) do
        self.timer:after(set.time, function()
            self:spawnKnifeGroup(set.count, set.charge, set.step, set.speed, set.offset)
        end)
    end
end

function KnifeDanceRing:update()
    self.ring_timer = self.ring_timer + DT

    if #self.ring_blades > 0 then
        local arena = Game.battle.arena
        local center_x = (arena.left + arena.right) / 2 + math.sin(self.ring_timer * 1.35) * 16
        local center_y = (arena.top + arena.bottom) / 2 + math.cos(self.ring_timer * 1.1) * 10
        local radius = 82 + math.sin(self.ring_timer * 1.7) * 7

        for _, bullet in ipairs(self.ring_blades) do
            if bullet.parent then
                local progress = math.min(self.ring_timer / self.time, 1)
                bullet.collidable = self.ring_timer >= 0.9
                bullet.ring_angle = bullet.ring_angle + ((0.014 + (progress * 0.035)) * DTMULT)
                bullet.rotation = bullet.ring_angle + math.pi
                bullet:setPosition(center_x + math.cos(bullet.ring_angle) * radius, center_y + math.sin(bullet.ring_angle) * radius)
            end
        end
    end

    super.update(self)
end

return KnifeDanceRing
