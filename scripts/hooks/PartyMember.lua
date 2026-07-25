local PartyMember, super = HookSystem.hookScript(PartyMember)

function PartyMember:drawPowerStat(index, x, y, menu)
    local result = super.drawPowerStat(self, index, x, y, menu)

    if self.has_act then
        if index == 1 and Game:getFlag("slain", 0) > 0 then
            love.graphics.print("*", x - 26, y)

            love.graphics.print("Slain", x, y)
            love.graphics.print(Game:getFlag("slain", 0), x + 130, y)

            return true
        elseif index == 2 and Game:getFlag("purified", 0) > 0 then
            love.graphics.print("*", x - 26, y)

            love.graphics.print("Purify", x, y)
            love.graphics.print(Game:getFlag("purified", 0), x + 130, y)

            return true
        end
    end
    return result
end

return PartyMember
