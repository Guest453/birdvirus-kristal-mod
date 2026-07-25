local Ch1Grass, super = Class(Event, "ch1_grass")

function Ch1Grass:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 0, data.height or 0, data)

    self.columns = math.max(1, math.floor((props.columns or 1) + 0.5))
    self.rows = math.max(1, math.floor((props.rows or 1) + 0.5))
    self.frames = props.frames or 9
    self.timer = 0
    self.textures = {}
    for frame = 0, self.frames - 1 do
        self.textures[frame + 1] = Assets.getTexture("world/ch1_dark/extracted/spr_tile_darkgrass_middle/" .. frame)
    end
    self.solid = false
    -- Grass belongs above the baked floor art, but below every character/event.
    self.layer = (WORLD_LAYERS["bottom"] or -1000) + 10
end

function Ch1Grass:update()
    self.timer = self.timer + DT
    super.update(self)
end

function Ch1Grass:draw()
    for column = 0, self.columns - 1 do
        for row = 0, self.rows - 1 do
            local phase = (self.x + self.y) / 320 + column * 0.125 + row * 0.125
            local frame = math.floor(self.timer * 6 + phase) % self.frames
            love.graphics.draw(self.textures[frame + 1], column * 40, row * 40)
        end
    end
end

return Ch1Grass
