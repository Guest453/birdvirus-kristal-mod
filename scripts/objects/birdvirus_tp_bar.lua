local BirdvirusTPBar, super = Class(Object, "birdvirus_tp_bar")

function BirdvirusTPBar:init(enemy)
    super.init(self, SCREEN_WIDTH - 54, 64, 38, 200)

    self.enemy = enemy
    self.bar_sprite = Sprite("birdvirus ui/birdvirustpbar")
    self.quads = {}
    self.layer = (BATTLE_LAYERS and (BATTLE_LAYERS["ui"] or BATTLE_LAYERS["above_arena"])) or 1000
    self.parallax_x = 0
    self.parallax_y = 0
end

function BirdvirusTPBar:update()
    if not self.enemy or not self.enemy.parent or self.enemy.noelle_route or not self.enemy.unvirus_unlocked then
        self:remove()
        return
    end

    super.update(self)
end

function BirdvirusTPBar:draw()
    super.draw(self)

    local texture = self.bar_sprite:getTexture()
    if not texture then
        return
    end

    local width, height = texture:getWidth(), texture:getHeight()
    local fill = math.max(0, math.min(1, (self.enemy.unvirus_meter or 0) / 100))

    love.graphics.push("all")

    -- Always-visible empty state, using the custom shape rather than a rectangular replacement.
    love.graphics.setColor(0.38, 0.42, 0.38, 0.9)
    love.graphics.draw(texture, 0, 0)

    if fill > 0 then
        local visible_height = math.max(1, math.floor(height * fill + 0.5))
        local crop_y = height - visible_height
        local quad = self.quads[visible_height]
        if not quad then
            quad = love.graphics.newQuad(0, crop_y, width, visible_height, width, height)
            self.quads[visible_height] = quad
        end

        local pulse = self.enemy.unvirus_complete
            and (0.82 + math.abs(math.sin((self.enemy.float_timer or 0) * 5)) * 0.18) or 1
        love.graphics.setColor(1, 1, 1, pulse)
        love.graphics.draw(texture, quad, 0, crop_y)
    end

    -- Quarter marks make each 25% ACT step legible while keeping the supplied artwork intact.
    love.graphics.setColor(106 / 255, 190 / 255, 48 / 255, 0.9)
    love.graphics.setLineWidth(2)
    for step = 1, 3 do
        local y = height - (height * step / 4)
        love.graphics.line(width - 5, y, width + 2, y)
    end

    love.graphics.pop()
end

return BirdvirusTPBar
