local MovingArena, super = Class(Wave)

function MovingArena:init()
    super.init(self)
    self.time = 8
    self.siner = 0
end

function MovingArena:onStart()
    -- Get the arena object
    local arena = Game.battle.arena

    self:spawnBulletTo(Game.battle.arena, "arenahazard", arena.width/2, 0, math.rad(0))
    self:spawnBulletTo(Game.battle.arena, "arenahazard", arena.width/2, arena.height, math.rad(180))
    self.arena_start_x = arena.x
    self.arena_start_y = arena.y
end

function MovingArena:update()
    self.siner = self.siner + DT
    -- Ease into the motion so the walls never jump under the soul at wave start.
    local intro = math.min(1, self.siner / 0.8)
    local offset = math.sin(self.siner * 1.35) * 48 * intro
    Game.battle.arena:setPosition(self.arena_start_x, self.arena_start_y + offset)

    super.update(self)
end

function MovingArena:onEnd(death)
    if Game.battle.arena then
        Game.battle.arena:setPosition(self.arena_start_x, self.arena_start_y)
    end
    super.onEnd(self, death)
end

return MovingArena
