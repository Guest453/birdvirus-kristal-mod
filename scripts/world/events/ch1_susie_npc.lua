local Ch1SusieNPC, super = Class(Event, "ch1_susie_npc")

function Ch1SusieNPC:init(data)
    super.init(self, data.x, data.y, data.width or 52, data.height or 92, data)

    self.textures = {}
    for frame = 0, 3 do
        self.textures[frame + 1] = Assets.getTexture(
            "world/ch1_dark/extracted/spr_susieu_dark/" .. frame
        )
    end
    self.frame = 0
    self.frame_timer = 0
    self.solid = true
end

function Ch1SusieNPC:onInteract()
    Game.world:startCutscene("ch1_dark", "susie_town")
    return true
end

function Ch1SusieNPC:update()
    self.frame_timer = self.frame_timer + DT
    if self.frame_timer >= 0.15 then
        self.frame_timer = self.frame_timer - 0.15
        self.frame = (self.frame + 1) % #self.textures
    end
    super.update(self)
end

function Ch1SusieNPC:draw()
    love.graphics.draw(self.textures[self.frame + 1], 0, 0, 0, 2, 2)
    super.draw(self)
end

return Ch1SusieNPC
