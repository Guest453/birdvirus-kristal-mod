local Ch1RudinnEncounter, super = Class(Encounter, "ch1_rudinn")

function Ch1RudinnEncounter:init()
    super.init(self)
    self.text = "* Rudinn drew near!"
    self.music = "battle"
    self.background = true
    self:addEnemy("ch1_rudinn")
end

return Ch1RudinnEncounter
