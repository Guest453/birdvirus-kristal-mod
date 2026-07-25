local Ch1Pushblock, super = Class(Event, "ch1_pushblock")

function Ch1Pushblock:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 40, data.height or 40, data)
    self.puzzle = props.puzzle
    self.texture = Assets.getTexture("world/ch1_dark/extracted/spr_npc_block/0")
    self.solid = true
end

function Ch1Pushblock:onInteract(player)
    player = player or (Game.world and Game.world.player)
    if not player then return false end
    local direction = player.facing or "down"
    local dx = direction == "left" and -40 or (direction == "right" and 40 or 0)
    local dy = direction == "up" and -40 or (direction == "down" and 40 or 0)
    self.solid = false
    local blocked = Game.world:checkCollision(Hitbox(self, dx, dy, 40, 40))
    self.solid = true
    if blocked then
        Assets.playSound("ch1_dark/noise", 0.4, 0.65)
        return true
    end
    self.x = self.x + dx
    self.y = self.y + dy
    Assets.playSound("ch1_dark/noise", 0.65, 0.8)
    return true
end

function Ch1Pushblock:draw()
    love.graphics.draw(self.texture, 0, 0, 0, 2, 2)
    super.draw(self)
end

return Ch1Pushblock
