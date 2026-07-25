--- DEBUG box-splitter: diagonal cuts only, parked fully open for 5 seconds each -- for eyeballing
--- the torn-triangle geometry. Not part of the real rotation.
local KnightBoxSplitDebug, super = Class(Wave)

function KnightBoxSplitDebug:init()
    super.init(self)
    local Base = Registry.getWave("knight_boxsplit")
    for _, m in ipairs({ "update", "draw", "onEnd", "computeTime",
                         "_startSlash", "_triggerSplit", "_buildHalves", "_updateHalves",
                         "_spawnToothBullet", "_spawnSplitBullets", "_updateSplitCycle", "_splitCycleDone" }) do
        self[m] = Base[m]
    end
    self.base_onStart = Base.onStart
    self.difficulty = 3
    self.force_diagonal = true   -- every cut is a diagonal
    self.hold_open = 300         -- park fully open for 5s before closing
    self.n_slashes = 2           -- one of each diagonal orientation (parity flips per slash)
    self:computeTime()
end

function KnightBoxSplitDebug:onStart()
    self.base_onStart(self)
    self.split_damage = 31
end

return KnightBoxSplitDebug
