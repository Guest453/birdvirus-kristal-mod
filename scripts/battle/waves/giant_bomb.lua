local GiantBomb, super = Class(Wave)

function GiantBomb:init()
    super.init(self)

    self.time = 8
    self:setArenaSize(300, 190)
end

function GiantBomb:onStart()
    self:spawnBullet("giantbomb", SCREEN_WIDTH / 2, -90)
end

function GiantBomb:update()
    super.update(self)
end

return GiantBomb
