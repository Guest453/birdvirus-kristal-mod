local Ch1Rudinn, super = Class(EnemyBattler, "ch1_rudinn")

function Ch1Rudinn:init()
    super.init(self)
    self.name = "Rudinn"
    self:setActor("ch1_rudinn")
    self.max_health = 90
    self.health = 90
    self.attack = 5
    self.defense = 0
    self.money = 40
    self.experience = 0
    self.waves = {"ch1_rudinn_diamonds"}
    self.dialogue = {"Long live the guy who pays us!", "Shine, shine!", "That's right!"}
    self.check = "AT 5 DEF 0\n* This ambivalent diamond isn't really sure why it's here."
    self:registerAct("Lecture")
end

function Ch1Rudinn:onAdd(parent)
    super.onAdd(self, parent)
    if self.sprite then
        self.sprite:setAnimation("idle")
        self.sprite:setScale(2)
    end
end

function Ch1Rudinn:onAct(battler, name)
    if name == "Lecture" then
        self:addMercy(50)
        return "* You lectured Rudinn on the importance of enthusiasm.\n* Rudinn became more convinced!"
    end
    return super.onAct(self, battler, name)
end

return Ch1Rudinn
