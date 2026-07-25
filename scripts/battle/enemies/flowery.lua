local Flowery, super = Class(EnemyBattler)

local VISUAL_SCALE = 1.35

local PHASE_DIALOGUE = {
    [1] = {
        "ALRIGHT, KRIS...\nHOLD AND RELEASE CANCEL\nTO CHARGE YOUR HEART!",
        "YOUR WORLD, YOUR FOUNTAIN...\nMORE IMPORTANT THAN OURS?",
        "I WON'T LOSE.\nMY FRIENDS ARE BEHIND ME!",
    },
    [2] = {
        "FEEL IT! SMELL IT!\nTHE POWER OF FLOWERS!",
        "WE COULD EVEN CALL IT\nA PACIFIST ROOT!",
    },
    [3] = {
        "SETH! REMEMBER THE\nPATTERNS I TAUGHT YOU!?",
        "AQUA! LET'S PLAY\nKNIFE CUTTING GAME!",
    },
    [4] = {
        "ORANGE! BE BRAVE.\nIT'S YOUR TURN!",
        "GREEN! HOW ABOUT\nA $999 TIP!?",
    },
    [5] = {
        "YELLOW! TONIGHT,\nJUSTICE RIDES TOGETHER!",
        "BLUE... PLAY YOUR PART!",
    },
    [6] = {
        "I DON'T NEED A TRIAL\nTO EXPOSE THE TRUTH!",
        "WITH YOUR POWERS COMBINED...\nOMEGA FLOWERY!",
    },
}

function Flowery:init()
    super.init(self)

    self.name = "Flowery"
    self:setActor("flowery")
    if self.sprite then
        self.sprite:setScale(VISUAL_SCALE)
    end
    if self.overlay_sprite then
        self.overlay_sprite:setScale(VISUAL_SCALE)
    end

    self.max_health = 3200
    self.health = self.max_health
    self.attack = 12
    self.defense = 8
    self.money = 500
    self.spare_points = 0

    self.phase = 1
    self.flowery_mercy = 0
    self.attack_count = 0
    self.omega = false
    self.ending_ready = false

    self.check = "AT 99 DF 8\n* The heroic flower standing between you and the Fountain.\n* Fighting will not change his mind."
    self.dialogue = PHASE_DIALOGUE[1]
    self.text = {
        "* Flowery emits the fragrance of hope!",
        "* Flowery holds onto his dream.",
        "* Flowery blooms in bravery.",
    }

    self:registerAct("Encourage", "Begin the\npeaceful route")
    self:registerAct("Blow Away", "Clear the\npetal storm")
    self:registerAct("Spin", "Match Seth\nand Aqua")
    self:registerAct("Praise", "Encourage\nthe brothers")
    self:registerAct("Justice", "Begin\nthe trial")
    self:registerAct("Susie's Idea", "Find another\nway", {"susie"})
end

function Flowery:setPhase(phase)
    phase = math.max(1, math.min(7, phase))
    if phase == self.phase then
        return
    end

    local previous_phase = self.phase
    self.phase = phase
    -- The source treats phases 1 and 2 as one continuous attack sequence.
    if not (previous_phase == 1 and phase == 2) then
        self.attack_count = 0
    end
    self.dialogue = PHASE_DIALOGUE[phase] or {"... ASGORE...\nI DID MY BEST."}

    if phase >= 6 and not self.omega then
        self.omega = true
        self.attack = 16
        self.defense = 4
        self.check = "AT 99 DF 4\n* Omega Flowery. Every borrowed technique blooms at once.\n* Susie has one last idea."
        if self.sprite then
            self.sprite:setAnimation("omega_powerup")
            self.sprite:setScale(VISUAL_SCALE)
            if Game.battle and Game.battle.timer then
                Game.battle.timer:after(0.55, function()
                    if self.parent and self.sprite then
                        self.sprite:setAnimation("omega_idle")
                        self.sprite:setScale(VISUAL_SCALE)
                    end
                end)
            end
        end
        Assets.playSound("snd_flowery_power_up", 0.9)
        Assets.playSound("snd_flowery_voiceclip_omega_flowery", 0.8)
    end

    if phase == 7 then
        self.ending_ready = true
        self.attack = 0
        self.defense = 0
        self.dialogue = {"... YOU FOUND\nANOTHER WAY."}
        self.text = {
            "* Flowery's petals finally settle.",
            "* The path to the Fountain is open.",
            "* Flowery can be SPARED.",
        }
    end
end

function Flowery:onHurt(damage, battler)
    -- Keep Kristal's normal hit shake/status handling, then force the correct
    -- extracted damage frame onto the overlay at Flowery's reduced scale.
    super.onHurt(self, damage, battler)
    self.hurt_timer = 0.4

    local hurt_sprite = self.omega and "omega_hurt" or "hurt"
    if self.overlay_sprite then
        self.overlay_sprite:setSprite(hurt_sprite)
        self.overlay_sprite:setScale(VISUAL_SCALE)
    elseif self.sprite then
        self.sprite:setSprite(hurt_sprite)
        self.sprite:setScale(VISUAL_SCALE)
    end
end

function Flowery:onHurtEnd()
    super.onHurtEnd(self)

    if self.sprite then
        self.sprite:setAnimation(self.omega and "omega_idle" or "idle")
        self.sprite:setScale(VISUAL_SCALE)
    end
    if self.overlay_sprite then
        self.overlay_sprite:setScale(VISUAL_SCALE)
    end
end

function Flowery:advanceMercy(amount)
    self.flowery_mercy = math.min(100, self.flowery_mercy + amount)
    self:addMercy(amount)

    if self.flowery_mercy >= 100 then
        self:setPhase(7)
    elseif self.flowery_mercy >= 50 then
        self:setPhase(6)
    elseif self.flowery_mercy >= 40 then
        self:setPhase(5)
    elseif self.flowery_mercy >= 30 then
        self:setPhase(4)
    elseif self.flowery_mercy >= 20 then
        self:setPhase(3)
    elseif self.flowery_mercy >= 10 then
        self:setPhase(2)
    end
end

function Flowery:selectWave()
    if self.ending_ready then
        self.selected_wave = nil
        return nil
    end

    self.attack_count = self.attack_count + 1
    local sequence
    if self.phase == 1 or self.phase == 2 then
        -- Other_11: choices 3,0,4,2,4,2 -> controller types 623,620,624,634,624,634.
        sequence = {"flowery_gml_623", "flowery_gml_620", "flowery_gml_624", "flowery_gml_634", "flowery_gml_624", "flowery_gml_634"}
        if self.attack_count > #sequence then
            self.attack_count = 5
        end
    elseif self.phase == 3 then
        -- Boxes Easy, Aqua Knives, Boxes Medium, then Aqua Knives.
        sequence = {"flowery_gml_630", "flowery_gml_641", "flowery_gml_631", "flowery_gml_641"}
        if self.attack_count > #sequence then self.attack_count = 2 end
    elseif self.phase == 4 then
        sequence = {"flowery_gml_636", "flowery_gml_638", "flowery_gml_632", "flowery_gml_638"}
        if self.attack_count > #sequence then self.attack_count = 1 end
    elseif self.phase == 5 then
        sequence = {"flowery_gml_635"}
        self.attack_count = 1
    else
        -- Super Jarona once, then the bullet-enhanced hard deflect.
        sequence = {"flowery_gml_639", "flowery_gml_622"}
        if self.attack_count > #sequence then self.attack_count = 2 end
    end

    self.selected_wave = sequence[self.attack_count]
    return self.selected_wave
end

function Flowery:onAct(battler, name)
    local required = ({
        [1] = "Encourage",
        [2] = "Blow Away",
        [3] = "Spin",
        [4] = "Praise",
        [5] = "Justice",
        [6] = "Susie's Idea",
    })[self.phase]

    if name == required then
        if self.phase == 6 then
            self:advanceMercy(50)
            Assets.playSound("snd_flowery_clash_cymbal", 0.9)
            return {
                "* Susie points past Flowery, toward another route to the Fountain.",
                "* For the first time, Flowery stops trying to prove himself.",
                "* OMEGA FLOWERY powers down.[wait:10]\n* Flowery can now be SPARED.",
            }
        end

        local old_phase = self.phase
        self:advanceMercy(10)
        local success = {
            [1] = "* You encourage Flowery's bravery without challenging it.\n* His guard softens.",
            [2] = "* The party blows together.\n* The petal storm parts instead of breaking.",
            [3] = "* You match Aqua and Seth's rhythm.\n* Flowery laughs despite himself.",
            [4] = "* You praise Orange and Green's teamwork.\n* Their combo ends in a proud pose.",
            [5] = "* You present the truth: nobody needs to lose.\n* Flowery's certainty finally cracks.",
        }
        return {success[old_phase], "* Mercy increased by 10%."}
    end

    if name ~= "Check" and name ~= "Standard" then
        return "* You tried "..name..".[wait:5]\n* That is not what Flowery needs to hear yet."
    end

    return super.onAct(self, battler, name)
end

function Flowery:getSpareText(battler, success)
    if success and self.ending_ready then
        return {
            "* Flowery lowers his fists and lets the party pass.",
            "* \"Guess a hero can protect people without beating somebody.\"",
            "* \"Tell Oldbuddy... I kept everyone safe.\"",
        }
    end
    return super.getSpareText(self, battler, success)
end

return Flowery
