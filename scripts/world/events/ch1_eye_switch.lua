local Ch1EyeSwitch, super = Class(Event, "ch1_eye_switch")

local function eyeFlag(index)
    return "ch1_dark_eye_" .. tostring(index)
end

function Ch1EyeSwitch:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 80, data.height or 80, data)
    self.index = props.index or 1
    self.textures = {}
    for frame = 0, 3 do
        self.textures[frame + 1] = Assets.getTexture(
            "world/ch1_dark/extracted/spr_shine/" .. frame
        )
    end
    self.timer = 0
    self.solid = false
end

function Ch1EyeSwitch:onInteract()
    if Game:getFlag("ch1_dark_eye_solved", false) then
        return true
    end

    local toggles = self.index == 1 and {1, 3}
        or (self.index == 2 and {1, 2} or {3})
    for _, index in ipairs(toggles) do
        Game:setFlag(eyeFlag(index), not Game:getFlag(eyeFlag(index), false))
    end
    Assets.playSound("ch1_dark/noise")

    if Game:getFlag(eyeFlag(1), false)
        and Game:getFlag(eyeFlag(2), false)
        and Game:getFlag(eyeFlag(3), false) then
        Game:setFlag("ch1_dark_eye_solved", true)
    end
    return true
end

function Ch1EyeSwitch:update()
    self.timer = self.timer + DT
    super.update(self)
end

function Ch1EyeSwitch:draw()
    if Game:getFlag(eyeFlag(self.index), false) then
        local frame = math.floor(self.timer * 8) % #self.textures
        love.graphics.draw(self.textures[frame + 1], 14, 10, 0, 2, 2)
    end
    super.draw(self)
end

return Ch1EyeSwitch
