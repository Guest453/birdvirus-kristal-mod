local actor, super = Class(Actor, "flowery")

function actor:init()
    super.init(self)

    self.name = "Flowery"
    self.width = 53
    self.height = 61
    self.path = "enemies/flowery"
    self.default = "idle"
    self.color = {1, 0.85, 0.2}
    self.voice = "snd_flowery_voicenoise_1"

    self.animations = {
        ["idle"] = {"idle", 0.18, true},
        ["powerup"] = {"powerup", 0.12, true},
        ["hurt"] = {"hurt", 0, false},
        ["omega_idle"] = {"omega_idle", 0.16, true},
        ["omega_powerup"] = {"omega_powerup", 0.1, true},
        ["omega_hurt"] = {"omega_hurt", 0, false},
    }

    self.offsets = {
        ["hurt"] = {0, 0},
        ["omega_hurt"] = {7, 0},
    }
end

return actor
