local Ch1SusiePortrait, super = Class(Actor, "ch1_susie_portrait")

function Ch1SusiePortrait:init()
    super.init(self)
    self.name = "Susie"
    self.voice = "susie"
    self.portrait_path = "face/ch1_susie"
    self.portrait_offset = {0, 0}
end

return Ch1SusiePortrait
