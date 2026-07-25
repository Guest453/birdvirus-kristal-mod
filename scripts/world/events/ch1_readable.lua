local Ch1Readable, super = Class(Event, "ch1_readable")

function Ch1Readable:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 20, data.height or 20, data)

    self.text = props.text
    self.repeat_text = props.repeat_text
    self.flag = props.flag
    self.action = props.action
    self.solid = false
end

function Ch1Readable:onInteract()
    if self.action then
        Game.world:startCutscene("ch1_dark", self.action, self)
        return true
    end

    local text = self.text
    if self.flag and self.repeat_text and Game:getFlag(self.flag, false) then
        text = self.repeat_text
    end
    if not text then
        return false
    end

    Game.world:startCutscene("ch1_dark", "prop_text", text)
    if self.flag then
        Game:setFlag(self.flag, true)
    end
    return true
end

return Ch1Readable
