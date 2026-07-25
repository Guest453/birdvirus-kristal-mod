local Ch1Prop, super = Class(Event, "ch1_prop")

function Ch1Prop:init(data)
    local props = data.properties or {}
    super.init(self, data.x, data.y, data.width or 0, data.height or 0, data)

    self.sprite_path = props.sprite
    self.frames = props.frames or 1
    self.frame = props.start_frame or 0
    self.textures = {}
    for i = 0, self.frames - 1 do
        self.textures[i + 1] = Assets.getTexture(self.sprite_path .. "/" .. i)
    end
    self.frame_timer = 0
    self.animation_speed = props.animation_speed or 0
    self.trigger = props.trigger
    self.triggered = not self.trigger
    self.sound = props.sound
    self.motion = props.motion
    self.motion_speed = props.motion_speed or 240
    self.interact_text = props.text
    self.interact_action = props.action
    self.solid = props.solid or false
    self.sprite_origin_x = props.origin_x or 0
    self.sprite_origin_y = props.origin_y or 0
    self.sprite_scale_x = props.scale_x or 1
    self.sprite_scale_y = props.scale_y or self.sprite_scale_x
end

function Ch1Prop:onInteract()
    if self.interact_action then
        Game.world:startCutscene("ch1_dark", self.interact_action, self)
        return true
    end
    if self.interact_text then
        Game.world:startCutscene("ch1_dark", "prop_text", self.interact_text)
        return true
    end
    return false
end

function Ch1Prop:activate()
    if self.triggered then
        return
    end

    self.triggered = true
    if self.sound then
        Assets.playSound(self.sound, 1, 0.8 + love.math.random() * 0.3)
    end
end

function Ch1Prop:update()
    local player = Game.world and Game.world.player
    if not self.triggered and player then
        if self.trigger == "near_x" and math.abs(player.x - self.x) < 60 then
            self:activate()
        elseif self.trigger == "lancer_up" and player.x > self.x - 650 then
            self:activate()
        elseif self.trigger == "lancer_right" and player.x > 80 then
            self:activate()
        end
    end

    if self.triggered and self.animation_speed > 0 and self.frames > 1 then
        self.frame_timer = self.frame_timer + DT
        if self.frame_timer >= self.animation_speed then
            self.frame_timer = self.frame_timer - self.animation_speed
            self.frame = (self.frame + 1) % self.frames
        end
    end

    if self.triggered and self.motion == "up" then
        self.y = self.y - self.motion_speed * DT
    elseif self.triggered and self.motion == "right" then
        self.x = self.x + self.motion_speed * DT
    end

    super.update(self)
end

function Ch1Prop:draw()
    local texture = self.textures[self.frame + 1]
    if texture then
        love.graphics.setColor(1, 1, 1, self.alpha)
        love.graphics.draw(
            texture, 0, 0, 0,
            self.sprite_scale_x, self.sprite_scale_y,
            self.sprite_origin_x, self.sprite_origin_y
        )
        love.graphics.setColor(1, 1, 1, 1)
    end
    super.draw(self)
end

return Ch1Prop
