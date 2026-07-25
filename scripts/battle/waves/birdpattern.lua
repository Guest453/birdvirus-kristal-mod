local BirdPattern, super = Class(Wave)

local function resizeArena(width, height)
    local arena = Game.battle.arena

    if arena.setSize then
        arena:setSize(width, height)
    elseif arena.resize then
        arena:resize(width, height)
    else
        arena.width = width
        arena.height = height
    end
end

function BirdPattern:init()
    super.init(self)
    self.time = 8
end

function BirdPattern:onStart()
    self.spin = 0

    -- This is the battle's one intentional arena resize. Later attacks keep the established box.
    resizeArena(210, 160)

    local function retireBullet(bullet)
        self.timer:after(2.35, function()
            if bullet.parent then
                bullet:fadeOutAndRemove(0.18)
            end
        end)
    end

    self.timer:every(0.70, function()
        local arena = Game.battle.arena
        local soul = Game.battle.soul
        local progress = math.min(self.spin / 10, 1)
        local x = (arena.left + arena.right) / 2 + math.sin(self.spin * 0.64) * 64
        local y = arena.top - 20
        local base = MathUtils.angle(x, y, soul.x, soul.y)
        local count = self.spin < 3 and 2 or (self.spin < 7 and 3 or 4)
        local gap = count == 4 and ((self.spin * 2) % count) + 1 or nil
        local spread = 0.12

        for i = 1, count do
            if i ~= gap then
                local centered = i - (count + 1) / 2
                local angle = base + centered * spread
                local bullet = self:spawnBullet("smallbullet", x + centered * 10, y,
                    angle, 3.35 + progress * 0.75)
                bullet.remove_offscreen = true
                retireBullet(bullet)
            end
        end

        -- Alternating side walls have a moving two-lane opening, so the fan and wall
        -- overlap into a route the player can read instead of a random cloud.
        if self.spin >= 3 and self.spin % 3 == 0 then
            local side = self.spin % 4 == 0 and arena.left - 18 or arena.right + 18
            local dir = side < arena.left and 0 or math.rad(180)
            local gap_lane = (math.floor(self.spin / 2) % 4) + 1
            for lane = 1, 5 do
                if lane ~= gap_lane and lane ~= gap_lane + 1 then
                    local bullet = self:spawnBullet("smallbullet", side,
                        arena.top + lane * arena.height / 6, dir, 3.0 + progress * 0.65)
                    bullet.remove_offscreen = true
                    retireBullet(bullet)
                end
            end
        end

        self.spin = self.spin + 1
    end)
end

function BirdPattern:update()
    super.update(self)
end

return BirdPattern
