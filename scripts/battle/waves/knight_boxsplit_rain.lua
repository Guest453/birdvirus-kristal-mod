local KnightBoxSplitRain, super = Class(Wave)

local function scaleDamage(wave, amount)
    local attacker = wave:getAttackers()[1]

    if attacker and attacker.scaleDamage then
        return attacker:scaleDamage(amount)
    end

    return amount
end

function KnightBoxSplitRain:init()
    super.init(self)

    local Base = Registry.getWave("knight_boxsplit")
    for _, m in ipairs({ "draw", "onEnd", "computeTime",
                         "_startSlash", "_triggerSplit", "_buildHalves", "_updateHalves",
                         "_spawnToothBullet", "_spawnSplitBullets", "_updateSplitCycle", "_splitCycleDone" }) do
        self[m] = Base[m]
    end

    self.base_onStart = Base.onStart
    self.base_update = Base.update
    self.difficulty = 1
    self:computeTime()
end

function KnightBoxSplitRain:onStart()
    self.base_onStart(self)
    self.split_damage = 31

    self.rain_timer = 0
    self.rain_column = 0
end

function KnightBoxSplitRain:spawnRainBullet()
    local arena = Game.battle.arena
    local margin = 14
    local columns = {0.16, 0.34, 0.52, 0.70, 0.88}
    local column = columns[(self.rain_column % #columns) + 1]
    local wobble = math.sin(self.rain_column * 1.7) * 8
    local x = arena.left + (arena.width * column) + wobble
    local y = arena.top - margin
    local angle = math.rad(90) + math.sin(self.rain_column * 0.9) * 0.08
    local bullet = self:spawnBullet("smallbullet", x, y, angle, 8.5)

    bullet.damage = scaleDamage(self, 31) + (self.snowgrave_damage_bonus or 0)
    bullet.remove_offscreen = false
    self.rain_column = self.rain_column + 1
end

function KnightBoxSplitRain:update()
    self.base_update(self)

    if not Game.battle.arena then
        return
    end

    self.rain_timer = self.rain_timer + DT
    if self.rain_timer >= 0.28 then
        self.rain_timer = self.rain_timer - 0.28
        self:spawnRainBullet()
    end
end

return KnightBoxSplitRain
