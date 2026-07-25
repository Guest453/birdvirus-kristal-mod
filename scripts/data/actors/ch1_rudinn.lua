local Ch1RudinnActor, super = Class(Actor, "ch1_rudinn")

function Ch1RudinnActor:init()
    super.init(self)
    self.name = "Rudinn"
    self.width = 35
    self.height = 40
    self.hitbox = {3, 22, 29, 18}
    self.color = {0, 0.8, 1}
    self.path = "world/ch1_dark/extracted"
    self.default = "idle"
    self.animations = {
        ["idle"] = {"spr_diamondm_idle", 0.15, true},
        ["hurt"] = {"spr_diamondm_hurt", 0, false},
        ["spared"] = {"spr_diamondm_spared", 0.15, true},
    }
end

function Ch1RudinnActor:onSpriteInit(sprite)
    sprite:setScale(2)
end

return Ch1RudinnActor
