local Ch1BlockTarget, super = Class(Event, "ch1_block_target")

function Ch1BlockTarget:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 40, data.height or 40, data)
    self.puzzle = props.puzzle
    self.texture = Assets.getTexture("world/ch1_dark/extracted/spr_glowtile_step/0")
    self.solid = false
    self.layer = (WORLD_LAYERS["bottom"] or -1000) + 15
end

function Ch1BlockTarget:draw()
    love.graphics.draw(self.texture, 0, 0, 0, 2, 2)
    super.draw(self)
end

return Ch1BlockTarget
