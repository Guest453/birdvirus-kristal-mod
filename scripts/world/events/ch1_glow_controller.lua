local Ch1GlowController, super = Class(Event, "ch1_glow_controller")

local function key(puzzle, suffix)
    return "ch1_glow_" .. puzzle .. "_" .. suffix
end

function Ch1GlowController:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 40, data.height or 40, data)
    self.puzzle = props.puzzle
    self.tile_count = props.tile_count or 3
    self.off = Assets.getTexture("world/ch1_dark/extracted/spr_hourglass_switch_off/0")
    self.active_timer = 0
    self.latch = false
    self.solid = false
end

function Ch1GlowController:update()
    local player = Game.world and Game.world.player
    if player and not Game:getFlag(key(self.puzzle, "solved"), false) then
        local inside = math.abs(player.x - (self.x + 20)) < 28 and math.abs(player.y - (self.y + 20)) < 28
        if inside and not self.latch and not Game:getFlag(key(self.puzzle, "active"), false) then
            self.latch = true
            self.active_timer = 0
            Game:setFlag(key(self.puzzle, "active"), true)
            Game:setFlag(key(self.puzzle, "count"), 0)
            Game:setFlag(key(self.puzzle, "serial"), (Game:getFlag(key(self.puzzle, "serial"), 0) or 0) + 1)
            Assets.playSound("ch1_dark/noise")
        end
        if not inside then self.latch = false end
        if Game:getFlag(key(self.puzzle, "active"), false) then
            self.active_timer = self.active_timer + DT
            if self.active_timer >= 8 then
                Game:setFlag(key(self.puzzle, "active"), false)
                Game:setFlag(key(self.puzzle, "serial"), (Game:getFlag(key(self.puzzle, "serial"), 0) or 0) + 1)
                Assets.playSound("ch1_dark/noise", 0.7, 0.65)
            end
        end
    end
    super.update(self)
end

function Ch1GlowController:draw()
    love.graphics.draw(self.off, 0, 0, 0, 2, 2)
    super.draw(self)
end

return Ch1GlowController
