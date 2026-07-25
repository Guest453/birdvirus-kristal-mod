local actor, super = Class(Actor, "ralsei_hat_ch1")

function actor:init()
    super.init(self)

    self.name = "Ralsei"
    self.width = 23
    self.height = 44
    self.hitbox = {2, 30, 19, 14}
    self.soul_offset = {12, 28}
    self.color = {0.2, 1, 0.2}
    self.path = "world/ch1_dark/extracted"
    self.default = "idle/down"
    self.voice = "ralsei"
    self.portrait_path = "face/ch1_ralsei"
    self.portrait_offset = {0, 0}
    self.can_blush = true

    self.animations = {
        ["walk/down"] = {"spr_ralseid", 4/30, true},
        ["walk/up"] = {"spr_ralseiu", 4/30, true},
        ["walk/left"] = {"spr_ralseil", 4/30, true},
        ["walk/right"] = {"spr_ralseir", 4/30, true},
        ["idle/down"] = {"spr_ralseid", 0, false},
        ["idle/up"] = {"spr_ralseiu", 0, false},
        ["idle/left"] = {"spr_ralseil", 0, false},
        ["idle/right"] = {"spr_ralseir", 0, false},
    }

    self.offsets = {}
end

function actor:onSpriteInit(sprite)
    sprite:setScale(2)
end

return actor
