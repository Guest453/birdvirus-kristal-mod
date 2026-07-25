local Ch1Treasure, super = Class(Event, "ch1_treasure")

function Ch1Treasure:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 40, data.height or 40, data)
    self.flag = props.flag or ("ch1_treasure_" .. tostring(data.id))
    self.closed = Assets.getTexture("world/ch1_dark/extracted/spr_treasurebox/0")
    self.opened = Assets.getTexture("world/ch1_dark/extracted/spr_treasurebox/1")
    self.is_open = Game:getFlag(self.flag, false)
    self.solid = true
end

function Ch1Treasure:onInteract()
    if self.is_open then
        Game.world:startCutscene("ch1_dark", "prop_text", "* (The chest is empty.)")
        return true
    end
    self.is_open = true
    Game:setFlag(self.flag, true)
    local item = Registry.getItem("darkcandy") and "darkcandy"
        or (Registry.getItem("dark_candy") and "dark_candy")
    if item then Game.inventory:tryGiveItem(item) end
    Assets.playSound("item")
    Game.world:startCutscene("ch1_dark", "prop_text", "* (You found a Dark Candy.)")
    return true
end

function Ch1Treasure:draw()
    love.graphics.draw(self.is_open and self.opened or self.closed, 0, 0, 0, 2, 2)
    super.draw(self)
end

return Ch1Treasure
