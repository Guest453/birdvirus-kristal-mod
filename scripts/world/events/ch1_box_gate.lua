local Ch1BoxGate, super = Class(Event, "ch1_box_gate")

function Ch1BoxGate:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 80, data.height or 80, data)
    self.puzzle = props.puzzle
    self.texture = Assets.getTexture("world/ch1_dark/extracted/spr_fencedoor/0")
    self.solved = Game:getFlag("ch1_box_puzzle_solved", false)
    self.solid = not self.solved
end

function Ch1BoxGate:update()
    if not self.solved then
        local blocks = Game.world:getEvents("ch1_pushblock")
        local targets = Game.world:getEvents("ch1_block_target")
        local occupied = 0
        for _, target in ipairs(targets) do
            for _, block in ipairs(blocks) do
                if math.abs(block.x - target.x) < 24 and math.abs(block.y - target.y) < 24 then
                    occupied = occupied + 1
                    break
                end
            end
        end
        if #targets > 0 and occupied >= #targets then
            self.solved = true
            self.solid = false
            Game:setFlag("ch1_box_puzzle_solved", true)
            Assets.playSound("item")
        end
    end
    super.update(self)
end

function Ch1BoxGate:draw()
    if not self.solved then
        love.graphics.draw(self.texture, 0, 0, 0, 2, 2, 4, 0)
    end
    super.draw(self)
end

return Ch1BoxGate
