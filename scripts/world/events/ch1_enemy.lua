local Ch1Enemy, super = Class(Event, "ch1_enemy")

function Ch1Enemy:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 70, data.height or 80, data)

    self.textures = {
        Assets.getTexture("world/ch1_dark/extracted/spr_diamond_overworld/0"),
        Assets.getTexture("world/ch1_dark/extracted/spr_diamond_overworld/1"),
    }
    self.encounter = props.encounter or "ch1_rudinn"
    self.defeated_flag = props.defeated_flag or ("ch1_enemy_" .. tostring(data.id))
    self.home_x, self.home_y = self.x, self.y
    self.frame = 0
    self.timer = 0
    self.alerted = false
    self.encountered = false
    self.solid = false

    self.defeated = Game:getFlag(self.defeated_flag, false)
    self.encountered = self.defeated
    self.visible = not self.defeated
end

function Ch1Enemy:update()
    local player = Game.world and Game.world.player
    if player and not self.encountered and not Game.world:hasCutscene() then
        local dx, dy = player.x - (self.x + 35), player.y - (self.y + 40)
        local distance = math.sqrt(dx * dx + dy * dy)
        if distance < 190 then
            self.alerted = true
        end
        if self.alerted and distance > 0 then
            local speed = 105 * DT
            self.x = self.x + dx / distance * speed
            self.y = self.y + dy / distance * speed
        end
        if distance < 42 then
            self.encountered = true
            self.visible = false
            Game:setFlag(self.defeated_flag, true)
            Game:encounter(self.encounter, true)
        end
    end

    self.timer = self.timer + DT
    self.frame = math.floor(self.timer * 6) % #self.textures
    super.update(self)
end

function Ch1Enemy:draw()
    love.graphics.draw(self.textures[self.frame + 1], 0, 0, 0, 2, 2)
    super.draw(self)
end

return Ch1Enemy
