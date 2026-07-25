--- Difficulty-0 variant of the box-splitter (see knight_boxsplit.lua for the difficulty table).
local KnightBoxSplit0, super = Class(Wave)

function KnightBoxSplit0:init()
    super.init(self)
    -- Borrow the base box-splitter's logic at runtime (load-order safe) and set our difficulty.
    local Base = Registry.getWave("knight_boxsplit")
    for _, m in ipairs({ "update", "draw", "onEnd", "computeTime",
                         "_startSlash", "_triggerSplit", "_buildHalves", "_updateHalves",
                         "_spawnToothBullet", "_spawnSplitBullets", "_updateSplitCycle", "_splitCycleDone" }) do
        self[m] = Base[m]
    end
    self.base_onStart = Base.onStart
    self.difficulty = 0
    self:computeTime()
end

function KnightBoxSplit0:onStart()
    self.base_onStart(self)
    self.split_damage = 31
end

return KnightBoxSplit0
