local Ch1GlowTile, super = Class(Event, "ch1_glow_tile")

local function key(puzzle, suffix)
    return "ch1_glow_" .. puzzle .. "_" .. suffix
end

function Ch1GlowTile:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 40, data.height or 40, data)
    self.puzzle = props.puzzle
    self.index = props.index
    self.off = Assets.getTexture("world/ch1_dark/extracted/spr_glowtile_off/0")
    self.on = Assets.getTexture("world/ch1_dark/extracted/spr_glowtile_step/0")
    self.serial = -1
    self.stepped = false
    self.solid = false
end

function Ch1GlowTile:update()
    local serial = Game:getFlag(key(self.puzzle, "serial"), 0) or 0
    if serial ~= self.serial then
        self.serial = serial
        self.stepped = false
    end
    local player = Game.world and Game.world.player
    if player and Game:getFlag(key(self.puzzle, "active"), false) and not self.stepped then
        if math.abs(player.x - (self.x + 20)) < 28 and math.abs(player.y - (self.y + 20)) < 28 then
            self.stepped = true
            local count = (Game:getFlag(key(self.puzzle, "count"), 0) or 0) + 1
            Game:setFlag(key(self.puzzle, "count"), count)
            Assets.playSound("ch1_dark/noise", 0.7, 1.25)
            local required = self.puzzle == "room_field_puzzle1" and 3 or 6
            if count >= required then
                local rounds = (Game:getFlag(key(self.puzzle, "rounds"), 0) or 0) + 1
                Game:setFlag(key(self.puzzle, "rounds"), rounds)
                Game:setFlag(key(self.puzzle, "active"), false)
                if rounds >= 1 then
                    Game:setFlag(key(self.puzzle, "solved"), true)
                    Assets.playSound("item")
                end
            end
        end
    end
    super.update(self)
end

function Ch1GlowTile:draw()
    love.graphics.draw(self.stepped and self.on or self.off, 0, 0, 0, 2, 2)
    super.draw(self)
end

return Ch1GlowTile
