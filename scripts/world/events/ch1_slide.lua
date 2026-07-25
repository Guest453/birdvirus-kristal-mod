local Ch1Slide, super = Class(Event, "ch1_slide")

function Ch1Slide:init(data)
    super.init(self, data.x, data.y, data.width, data.height, data)
    self.solid = false
    self.was_inside = false
end

function Ch1Slide:update()
    local player = Game.world and Game.world.player
    if player then
        local inside = player.x >= self.x and player.x <= self.x + self.width
            and player.y >= self.y and player.y <= self.y + self.height
        if inside then
            player.y = player.y + 360 * DT
            if not self.was_inside then
                Assets.playSound("ch1_dark/noise")
                Assets.playSound("ch1_dark/paper_surf", 0.7)
            end
        end
        self.was_inside = inside
    end

    super.update(self)
end

return Ch1Slide
