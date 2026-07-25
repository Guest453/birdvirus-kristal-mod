local Ch1LancerPortrait, super = Class(Actor, "ch1_lancer_portrait")

function Ch1LancerPortrait:init()
    super.init(self)
    self.name = "Lancer"
    self.voice = "lancer"
    self.portrait_path = "face/ch1_lancer"
    self.portrait_offset = {0, 0}
end

return Ch1LancerPortrait
