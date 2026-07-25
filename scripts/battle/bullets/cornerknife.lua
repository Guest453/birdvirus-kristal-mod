local CornerKnife, super = Class(Bullet)

local function approach(value, target, amount)
    if value < target then
        return math.min(value + amount, target)
    elseif value > target then
        return math.max(value - amount, target)
    end

    return target
end

function CornerKnife:init(center_x, center_y, angle, radius, spin_speed, charge_time, charge_speed, aim_pause)
    local x = center_x + math.cos(angle) * radius
    local y = center_y + math.sin(angle) * radius

    super.init(self, x, y, "bullets/birdvirusSWORD")

    self:setOriginExact(34, 31)
    self.collider = Hitbox(self, 10, 14, 49, 34)
    self.damage = 20

    self.center_x = center_x
    self.center_y = center_y
    self.orbit_angle = angle
    self.radius = radius
    self.spin_speed = spin_speed
    self.charge_time = charge_time
    self.aim_pause = aim_pause or 1
    self.charge_speed = charge_speed or 22
    self.timer = 0
    self.state = "orbit"
    self.state_timer = 0
    self.target_speed = 0
    self.trail_timer = 0
    self.trail_points = {}
    self.trail_sprites = {}

    self.physics.speed = 0
    self.rotation = angle + math.pi
    self.remove_offscreen = false
    self.collidable = false
    self:setScale(0.75)

    -- Use real sword sprites for the dash trail, matching Birdvirus's pooled afterimages.
    for i = 1, 6 do
        local trail = Sprite("birdvirusSWORD", 0, 0, nil, nil, "bullets")
        trail:setOriginExact(34, 31)
        trail:setLayer(-1)
        trail:setColor(1, 0.35, 0.35, 0)
        self:addChild(trail)
        table.insert(self.trail_sprites, trail)
    end
end

function CornerKnife:getDamage()
    local damage = super.getDamage(self)

    if self.attacker and self.attacker.scaleDamage then
        return self.attacker:scaleDamage(damage)
    end

    return damage
end

function CornerKnife:updateTrail()
    if self.state ~= "charge" then
        self.trail_timer = 0
        self.trail_points = {}
    else
        self.trail_timer = self.trail_timer + DT
        if self.trail_timer >= 0.025 then
            table.insert(self.trail_points, 1, {
                x = self.x,
                y = self.y,
                rotation = self.rotation,
            })
            self.trail_timer = self.trail_timer - 0.025

            while #self.trail_points > 18 do
                table.remove(self.trail_points)
            end
        end
    end

    local scale_x = self.scale_x ~= 0 and self.scale_x or 1
    local scale_y = self.scale_y ~= 0 and self.scale_y or 1
    local c, s = math.cos(-self.rotation), math.sin(-self.rotation)

    for i, trail in ipairs(self.trail_sprites) do
        local point = self.trail_points[i * 2]
        if point then
            local world_x = point.x - self.x
            local world_y = point.y - self.y
            local local_x = (world_x * c - world_y * s) / scale_x
            local local_y = (world_x * s + world_y * c) / scale_y
            local alpha = 0.32 * (1 - ((i - 1) / #self.trail_sprites))

            trail:setPosition(local_x, local_y)
            trail.rotation = point.rotation - self.rotation
            trail:setColor(1, 0.35, 0.35, alpha)
        else
            trail:setColor(1, 0.35, 0.35, 0)
        end
    end
end

function CornerKnife:update()
    self.timer = self.timer + DT
    self.state_timer = self.state_timer + DT
    if self.state == "orbit" then
        self.orbit_angle = self.orbit_angle + (self.spin_speed * DTMULT)
        self.x = self.center_x + math.cos(self.orbit_angle) * self.radius
        self.y = self.center_y + math.sin(self.orbit_angle) * self.radius
        self.rotation = self.orbit_angle + math.pi

        if self.timer >= self.charge_time then
            self.state = "aim"
            self.state_timer = 0
            self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
            self.rotation = self.physics.direction + math.pi
            self.physics.speed = 0
            self.target_speed = self.charge_speed
        end
    elseif self.state == "aim" then
        self.physics.speed = 0

        if self.state_timer >= self.aim_pause then
            self.state = "charge"
            self.state_timer = 0
            self.physics.speed = 2
            self.collidable = true
        end
    else
        self.physics.speed = approach(self.physics.speed, self.target_speed, 1.25 * DTMULT)
    end

    super.update(self)
    self:updateTrail()
end

function CornerKnife:draw()
    if self.state == "aim" then
        local pulse = 0.25 + math.abs(math.sin(self.state_timer * 18)) * 0.3
        love.graphics.setLineWidth(2)
        love.graphics.setColor(1, 0.1, 0.1, pulse)
        -- draw through the sprite origin, which is the knife's movement axis.
        love.graphics.line(34, 31, 34 - 620, 31)
    end

    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
    super.draw(self)
end

return CornerKnife
