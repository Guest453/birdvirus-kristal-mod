local Ch1EyeGate, super = Class(Event, "ch1_eye_gate")

function Ch1EyeGate:init(data)
    super.init(self, data.x, data.y, data.width or 60, data.height or 80, data)
    self.texture = Assets.getTexture("world/ch1_dark/extracted/spr_magicalglass/0")
    self.solid = not Game:getFlag("ch1_dark_eye_solved", false)
end

function Ch1EyeGate:update()
    self.solid = not Game:getFlag("ch1_dark_eye_solved", false)
    super.update(self)
end

function Ch1EyeGate:draw()
    if self.solid then
        for column = 0, 2 do
            for row = 0, 1 do
                love.graphics.draw(self.texture, column * 20, row * 40)
            end
        end
    end
    super.draw(self)
end

return Ch1EyeGate
