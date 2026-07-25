local ChargedKnife, super = Class(Bullet)

local function approach(value, target, amount)
    if value < target then
        return math.min(value + amount, target)
    elseif value > target then
        return math.max(value - amount, target)
    end

    return target
end

function ChargedKnife:init(x, y, dir, charge_time, slash_speed)
    super.init(self, x, y, "bullets/birdvirusSWORD")

    -- The visible art occupies x=9..59, y=13..48 inside its 64x64 canvas.
    self:setOriginExact(34, 31)
    self.collider = Hitbox(self, 10, 14, 49, 34)
    self.damage = 20

    self.physics.direction = dir
    self.physics.speed = 0
    -- birdvirusSWORD faces left in its source image (handle on the right).
    self.rotation = dir + math.pi
    self.remove_offscreen = false
    self.base_scale = 0.78
    self:setScale(self.base_scale)

    -- Pull back and lunge along the blade's actual travel vector, regardless of its angle.
    self.start_x = x - math.cos(dir) * 14
    self.start_y = y - math.sin(dir) * 14
    self.charge_x = x + math.cos(dir) * 8
    self.charge_y = y + math.sin(dir) * 8
    self.x = self.start_x
    self.y = self.start_y
    self.charge_time = charge_time or 0.85
    self.slash_speed = slash_speed or 20
    self.charge_timer = 0
    self.charging = true
    self.line_alpha = 0
    self.collidable = false
    self.trail_timer = 0
    self.trail_points = {}
    self.trail_sprites = {}

    for i = 1, 6 do
        local trail = Sprite("birdvirusSWORD", 0, 0, nil, nil, "bullets")
        trail:setOriginExact(34, 31)
        trail:setLayer(-1)
        trail:setColor(1, 0.35, 0.35, 0)
        self:addChild(trail)
        table.insert(self.trail_sprites, trail)
    end
end

function ChargedKnife:getDamage()
    local damage = super.getDamage(self)

    if self.attacker and self.attacker.scaleDamage then
        return self.attacker:scaleDamage(damage)
    end

    return damage
end

function ChargedKnife:update()
    self.charge_timer = self.charge_timer + DT

    if self.charging then
        local progress = math.min(self.charge_timer / self.charge_time, 1)
        local eased = 1 - ((1 - progress) * (1 - progress))

        self.x = self.start_x + ((self.charge_x - self.start_x) * eased)
        self.y = self.start_y + ((self.charge_y - self.start_y) * eased)
        self.line_alpha = math.min(progress * 0.35, 0.35)
        self:setScale(self.base_scale + (math.sin(progress * math.pi) * 0.18))

        if progress >= 1 then
            self.charging = false
            self.line_alpha = 0
            self:setScale(self.base_scale)
            self.physics.speed = 2
            self.collidable = true
        end
    else
        self.physics.speed = approach(self.physics.speed, self.slash_speed, 1.15 * DTMULT)
    end

    super.update(self)
    self:updateTrail()
end

function ChargedKnife:updateTrail()
    if self.charging then
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
            local alpha = 0.3 * (1 - ((i - 1) / #self.trail_sprites))

            trail:setPosition(local_x, local_y)
            trail.rotation = point.rotation - self.rotation
            trail:setColor(1, 0.35, 0.35, alpha)
        else
            trail:setColor(1, 0.35, 0.35, 0)
        end
    end
end

function ChargedKnife:draw()
    if self.line_alpha > 0 then
        love.graphics.setLineWidth(2)
        love.graphics.setColor(1, 0, 0, self.line_alpha)
        -- draw through the sprite origin, which is the knife's movement axis.
        love.graphics.line(34, 31, 34 - 620, 31)
    end

    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
    super.draw(self)
end

return ChargedKnife
