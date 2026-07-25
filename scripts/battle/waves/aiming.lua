local Aiming, super = Class(Wave)

function Aiming:init()
    super.init(self)
    self.time = 8
end

function Aiming:onStart()
    self.volley = 0

    -- Fire readable three-bullet fans instead of an unbroken stream of exact homing shots.
    self.timer:every(0.8, function()
        local attackers = self:getAttackers()
        for _, attacker in ipairs(attackers) do
            local x, y = attacker:getRelativePos(attacker.width / 2, attacker.height / 2)
            local angle = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            for _, offset in ipairs({-0.16, 0, 0.16}) do
                local bullet = self:spawnBullet("smallbullet", x, y, angle + offset, 6.5 + self.volley * 0.08)
                bullet.remove_offscreen = false
            end
        end

        self.volley = self.volley + 1
    end)
end

function Aiming:update()
    super.update(self)
end

return Aiming
