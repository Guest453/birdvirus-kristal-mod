--- Difficulty-2 variant of the box-splitter (see knight_boxsplit.lua for the difficulty table).
local KnightBoxSplit2, super = Class(Wave)

function KnightBoxSplit2:init()
    super.init(self)
    -- Borrow the base box-splitter's logic at runtime (load-order safe) and set our difficulty.
    local Base = Registry.getWave("knight_boxsplit")
    for _, m in ipairs({ "update", "draw", "onEnd", "computeTime",
                         "_startSlash", "_triggerSplit", "_buildHalves", "_updateHalves",
                         "_spawnToothBullet", "_spawnSplitBullets", "_updateSplitCycle", "_splitCycleDone" }) do
        self[m] = Base[m]
    end
    self.base_onStart = Base.onStart
    self.difficulty = 2
    self:computeTime()
end

function KnightBoxSplit2:onStart()
    self.base_onStart(self)
    self.split_damage = 31
end

return KnightBoxSplit2
