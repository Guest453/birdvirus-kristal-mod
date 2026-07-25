local Ch1RudinnDiamonds, super = Class(Wave, "ch1_rudinn_diamonds")

function Ch1RudinnDiamonds:init()
    super.init(self)
    self.time = 6
    self:setArenaSize(230, 160)
end

function Ch1RudinnDiamonds:onStart()
    local volley = 0
    self.timer:every(0.62, function()
        local arena = Game.battle.arena
        local safe_lane = (volley % 5) + 1
        for lane = 1, 5 do
            if lane ~= safe_lane and (lane + volley) % 2 == 0 then
                local x = arena.left + lane * arena.width / 6
                local y = arena.top - 18
                local direction = math.pi / 2
                local bullet = self:spawnBullet(
                    "world/ch1_dark/extracted/spr_diamondbullet/0", x, y
                )
                bullet.physics.direction = direction
                bullet.physics.speed = 5
                bullet.rotation = math.pi / 4
                bullet.physics.spin = lane % 2 == 0 and 0.06 or -0.06
                bullet.damage = 6
                bullet.collider = Hitbox(bullet, 3, 3, bullet.width - 6, bullet.height - 6)
            end
        end
        volley = volley + 1
    end)
end

function Ch1RudinnDiamonds:update()
    super.update(self)
end

return Ch1RudinnDiamonds
