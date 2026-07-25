local Ch1GlowGate, super = Class(Event, "ch1_glow_gate")

function Ch1GlowGate:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 120, data.height or 80, data)
    self.puzzle = props.puzzle
    self.solid = true
end

function Ch1GlowGate:update()
    self.solid = not Game:getFlag("ch1_glow_" .. self.puzzle .. "_solved", false)
    super.update(self)
end

return Ch1GlowGate
