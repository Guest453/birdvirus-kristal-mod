local Ch1SpadeChase, super = Class(Event, "ch1_spade_chase")

function Ch1SpadeChase:init(data)
    super.init(self, data.x, data.y, data.width or 40, data.height or 40, data)
    self.lancer = Assets.getFrames("world/ch1_dark/extracted/spr_darklancer")
    self.active = false
    self.finished = false
    self.spawn_timer = 0
    self.frame_timer = 0
    self.solid = false
end

function Ch1SpadeChase:update()
    local player = Game.world and Game.world.player
    if not player or self.finished or Game.world:hasCutscene() then
        super.update(self)
        return
    end

    if not self.active and player.x >= 1060 then
        self.active = true
        Game.world:setBattle(true)
        Assets.playSound("ch1_dark/wobbler")
    end

    if self.active then
        self.frame_timer = self.frame_timer + DT
        self.spawn_timer = self.spawn_timer + DT
        if self.spawn_timer >= 0.72 then
            self.spawn_timer = self.spawn_timer - 0.72
            local spawn_x = player.x + 380
            local spawn_y = player.y + love.math.random(-130, 130)
            local direction = math.atan2(player.y - spawn_y, player.x - spawn_x)
            Game.world:spawnBullet("ch1_spade", spawn_x, spawn_y, direction, 285)
            Assets.playSound("ch1_dark/noise", 0.55, 1.1)
        end

        if player.x >= 5150 then
            self.active = false
            self.finished = true
            Game.world:setBattle(false)
        end
    end
    super.update(self)
end

function Ch1SpadeChase:draw()
    if not self.finished and self.lancer and #self.lancer > 0 then
        local frame = math.floor(self.frame_timer * 4) % #self.lancer + 1
        love.graphics.draw(self.lancer[frame], 500, -160, 0, 2, 2)
    end
    super.draw(self)
end

function Ch1SpadeChase:onRemove(parent)
    if self.active and Game.world then
        Game.world:setBattle(false)
    end
    super.onRemove(self, parent)
end

return Ch1SpadeChase
