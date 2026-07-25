local Ch1RudinnDuo, super = Class(Encounter, "ch1_rudinn_duo")

function Ch1RudinnDuo:init()
    super.init(self)
    self.text = "* Rudinn and Rudinn blocked the way!"
    self.music = "battle"
    self.background = true
    self:addEnemy("ch1_rudinn", 500, 170)
    self:addEnemy("ch1_rudinn", 550, 250)
end

return Ch1RudinnDuo
