local PartyBattler, super = HookSystem.hookScript(PartyBattler)

function PartyBattler:hurt(amount, exact, color, options)
    local encounter = Game.battle and Game.battle.encounter
    if encounter and encounter.toggle_shadow_mantle_all_bullets
        and self.chara and self.chara.checkArmor and self.chara:checkArmor("shadowmantle") then
        amount = amount * 0.5
    end
    return super.hurt(self, amount, exact, color, options)
end

return PartyBattler
