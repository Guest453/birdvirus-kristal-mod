local FloweryGMLJarona, super = Class(Bullet)

function FloweryGMLJarona:init(x, y, speed, mode, difficulty)
    super.init(self, x, y, "bullets/flowery/jarona_windup")
    self:setOrigin(0.5, 0.5)
    self:setScale(1.35)
    self.collider = Hitbox(self, -18, -28, 36, 56)
    self.damage = 24
    self.charge_speed = (speed or 20) * 0.47
    self.mode = mode or 0
    self.difficulty = difficulty or 0
    self.state = "windup"
    self.timer = 0
    self.collidable = false
    self.remove_offscreen = false
end

function FloweryGMLJarona:update()
    self.timer = self.timer + DTMULT
    if self.state == "windup" and self.timer >= 18 then
        self.state = "charge"
        self.timer = 0
        self:setSprite("bullets/flowery/jarona_punch")
        self:setOrigin(0.5, 0.5)
        self.collidable = true
        Assets.playSound("snd_flowery_voiceclip_heh_it_s_my_jarona", 0.55)
    elseif self.state == "charge" then
        self.x = self.x - self.charge_speed * DTMULT
        if self.x < Game.battle.arena.left - 45 then
            self:remove()
        end
    elseif self.state == "deflected" then
        self.x = self.x + 11 * DTMULT
        self.rotation = self.rotation + 0.18 * DTMULT
        if self.x > Game.battle.arena.right + 70 then
            self:remove()
        end
    end
    super.update(self)
end

function FloweryGMLJarona:onCollide(soul)
    if soul.flowery_dashing then
        self.state = "deflected"
        self.timer = 0
        self.collidable = false
        self:setSprite("bullets/flowery/jarona_deflected")
        self:setOrigin(0.5, 0.5)
        Assets.playSound("snd_flowery_clash_cymbal", 0.8)
        return
    end
    return super.onCollide(self, soul)
end

return FloweryGMLJarona
