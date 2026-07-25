local FloweryGMLWall, super = Class(Bullet)

function FloweryGMLWall:init(x, y, width, height, speed, bullet_lines)
    super.init(self, x, y, "bullets/flowery/seed")
    self.wall_width = width or 12
    self.wall_height = height or 40
    self:setOrigin(0.5, 0.5)
    self.collider = Hitbox(self, -self.wall_width / 2, -self.wall_height / 2, self.wall_width, self.wall_height)
    self.damage = 18
    self.physics.direction = math.pi
    self.physics.speed = speed or 8
    self.remove_offscreen = false
    self.bullet_lines = bullet_lines
    self.alpha = 0
end

function FloweryGMLWall:draw()
    love.graphics.setColor(0.2, 0.85, 0.28, 1)
    love.graphics.rectangle("fill", -self.wall_width / 2, -self.wall_height / 2, self.wall_width, self.wall_height)
    love.graphics.setColor(0.75, 1, 0.4, 1)
    love.graphics.rectangle("line", -self.wall_width / 2, -self.wall_height / 2, self.wall_width, self.wall_height)
    if self.bullet_lines then
        love.graphics.setColor(1, 0.8, 0.15, 0.8)
        for y = -self.wall_height / 2 + 12, self.wall_height / 2 - 8, 18 do
            love.graphics.circle("fill", 0, y, 3)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function FloweryGMLWall:onCollide(soul)
    if soul.flowery_dashing then
        Assets.playSound("snd_flowery_clash_cymbal", 0.35)
        self:remove()
        return
    end
    return super.onCollide(self, soul)
end

return FloweryGMLWall
