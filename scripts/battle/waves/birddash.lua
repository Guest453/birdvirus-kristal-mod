local BirdDash, super = Class(Wave)

local function approach(value, target, amount)
    if value < target then
        return math.min(value + amount, target)
    elseif value > target then
        return math.max(value - amount, target)
    end

    return target
end

function BirdDash:init()
    super.init(self)
    self.time = 8
    self.dash_clock = 0
end

function BirdDash:onStart()
    local spawns = {
        {side = "left",  offset = 0.25, charge = 0.90, speed = 8.0},
        {side = "top",   offset = 0.68, charge = 0.88, speed = 8.2},
        {side = "right", offset = 1.20, charge = 0.85, speed = 8.5},
        {side = "left",  offset = 1.62, charge = 0.82, speed = 8.7},
        {side = "top",   offset = 2.10, charge = 0.80, speed = 9.0},
        {side = "right", offset = 2.52, charge = 0.78, speed = 9.2},
        {side = "left",  offset = 3.00, charge = 0.75, speed = 9.5},
        {side = "right", offset = 3.42, charge = 0.75, speed = 9.5},
        {side = "top",   offset = 3.82, charge = 0.72, speed = 9.8},
        {side = "left",  offset = 4.12, charge = 0.70, speed = 9.8},
        {side = "top",   offset = 4.45, charge = 0.68, speed = 10.0},
        {side = "right", offset = 4.82, charge = 0.65, speed = 10.2},
        {side = "left",  offset = 5.20, charge = 0.62, speed = 10.5},
        {side = "right", offset = 5.50, charge = 0.62, speed = 10.5},
        {side = "top",   offset = 5.78, charge = 0.58, speed = 10.8},
        {side = "left",  offset = 6.02, charge = 0.58, speed = 10.8},
        {side = "right", offset = 6.30, charge = 0.52, speed = 11.0},
        {side = "top",   offset = 6.55, charge = 0.52, speed = 11.0},
        {side = "left",  offset = 6.80, charge = 0.50, speed = 11.2},
        {side = "right", offset = 7.02, charge = 0.50, speed = 11.2},
        {side = "top",   offset = 7.24, charge = 0.48, speed = 11.5},
        {side = "left",  offset = 7.46, charge = 0.48, speed = 11.5},
    }

    for spawn_index, spawn in ipairs(spawns) do
        local spawn_data = spawn
        local index = spawn_index
        self.timer:after(spawn_data.offset, function()
            local arena = Game.battle.arena
            local x, y, entrance_angle
            local lane = ((index - 1) % 3) - 1
            local position = 0.16 + (((index * 0.37) % 0.68))

            if spawn_data.side == "left" then
                x = arena.left - 18
                y = arena.top + arena.height * position
                entrance_angle = 0
            elseif spawn_data.side == "right" then
                x = arena.right + 18
                y = arena.top + arena.height * position
                entrance_angle = math.rad(180)
            else
                x = arena.left + arena.width * position
                y = arena.top - 18
                entrance_angle = math.rad(90)
            end

            local bullet = self:spawnBullet("smallbullet", x, y, entrance_angle, 0.8)
            bullet.remove_offscreen = false
            bullet.target_speed = nil
            bullet.dash_charging = true
            bullet.collidable = false
            bullet:setScale(1.35)

            self.timer:after(spawn_data.charge, function()
                if bullet.physics and bullet.parent then
                    local target_x, target_y = Game.battle.soul.x, Game.battle.soul.y
                    if spawn_data.side == "top" then
                        target_x = target_x + lane * 34
                    else
                        target_y = target_y + lane * 30
                    end
                    local angle = MathUtils.angle(bullet.x, bullet.y, target_x, target_y)
                    bullet.physics.direction = angle
                    bullet.target_speed = spawn_data.speed
                    bullet.dash_charging = false
                    bullet.collidable = true
                    bullet:setScale(1)
                end
            end)
        end)
    end
end

function BirdDash:update()
    self.dash_clock = self.dash_clock + DT

    for _, bullet in ipairs(self.bullets or {}) do
        if bullet.target_speed and bullet.physics then
            bullet.physics.speed = approach(bullet.physics.speed, bullet.target_speed, 0.65 * DTMULT)
        elseif bullet.dash_charging then
            local pulse = 1.2 + math.abs(math.sin(self.dash_clock * 12)) * 0.25
            bullet:setScale(pulse)
        end
    end

    super.update(self)
end

return BirdDash
