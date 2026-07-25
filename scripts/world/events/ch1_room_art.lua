local Ch1RoomArt, super = Class(Event, "ch1_room_art")

function Ch1RoomArt:init(data)
    super.init(self, data.x, data.y, data.width or 0, data.height or 0, data)

    self.solid = false
    self.texture = Assets.getTexture(data.properties.texture)
    self.layer = (WORLD_LAYERS["bottom"] or -1000) - 100
end

function Ch1RoomArt:draw()
    love.graphics.draw(self.texture, 0, 0)
end

return Ch1RoomArt
