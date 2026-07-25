local FloweryEncounter, super = Class(Encounter)

function FloweryEncounter:init()
    super.init(self)

    self.text = "* Flowery blocks the way to the Fountain!"
    self.music = "battle"
    self.background = true
    self:addEnemy("flowery")
end

return FloweryEncounter
