local Basic, super = Class(Wave)

function Basic:init()
    super.init(self)
    self.time = 8
end

function Basic:onStart()
    self.volley = 0

    -- Alternating three-shot curtains always leave a visibly wider lane on one side.
    self.timer:every(0.52, function()
        local arena = Game.battle.arena
        local from_left = self.volley % 2 == 1
        local gap_y = (self.volley % 4 < 2) and arena.top + arena.height * 0.3
            or arena.top + arena.height * 0.7
        local x = from_left and arena.left - 20 or arena.right + 20
        local direction = from_left and 0 or math.pi

        for lane = 1, 5 do
            local y = arena.top + lane * arena.height / 6
            if math.abs(y - gap_y) > 22 then
                local bullet = self:spawnBullet("smallbullet", x, y, direction, 6.5)
                bullet.remove_offscreen = false
            end
        end

        self.volley = self.volley + 1
    end)
end

function Basic:update()
    super.update(self)
end

return Basic
