local Ch1GetSusie, super = Class(Event, "ch1_getsusie")

function Ch1GetSusie:init(data)
    super.init(self, data.x, data.y, data.width or 52, data.height or 92, data)
    self.textures = {}
    for frame = 0, 3 do
        self.textures[frame + 1] = Assets.getTexture(
            "world/ch1_dark/extracted/spr_susieu_dark/" .. frame
        )
    end
    self.frame = 0
    self.timer = 0
    self.started = Game:getFlag("ch1_getsusie_done", false)
    self.visible = not self.started
    self.solid = false
end

function Ch1GetSusie:update()
    local player = Game.world and Game.world.player
    if player and not self.started and player.x >= self.x - 80 and not Game.world:hasCutscene() then
        self.started = true
        Game.world:startCutscene("ch1_dark", "getsusie", self)
    end
    self.timer = self.timer + DT
    self.frame = math.floor(self.timer * 6) % #self.textures
    super.update(self)
end

function Ch1GetSusie:draw()
    love.graphics.draw(self.textures[self.frame + 1], 0, 0, 0, 2, 2)
    super.draw(self)
end

return Ch1GetSusie
