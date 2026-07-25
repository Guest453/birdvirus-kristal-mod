local BirdvirusCallKrisPunchline, super = Class(Object)

function BirdvirusCallKrisPunchline:init()
    super.init(self, 0, 0)
    self.layer = 1000000
    self.texture = Assets.getTexture("birdvirus ui/HOLYSHIT")
end

function BirdvirusCallKrisPunchline:draw()
    love.graphics.push("all")
    love.graphics.setColor(1, 1, 1, 1)

    local width, height = self.texture:getDimensions()
    local scale = 2
    local image_x = (SCREEN_WIDTH - width * scale) / 2
    local image_y = SCREEN_HEIGHT - height * scale - 62
    love.graphics.draw(self.texture, image_x, image_y, 0, scale, scale)

    love.graphics.setFont(Assets.getFont("main", 24))
    love.graphics.printf("WHO INVITED HIM?", 0, SCREEN_HEIGHT - 48, SCREEN_WIDTH, "center")
    love.graphics.pop()

    super.draw(self)
end

return BirdvirusCallKrisPunchline
