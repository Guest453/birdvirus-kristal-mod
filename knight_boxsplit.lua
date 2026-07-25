--- KnightBoxSplit: DELTARUNE Ch3 obj_knight_split_growtangle (the "Flurry"/box-splitter attack's core
--- box mechanic, WITHOUT the slash/bullet-wave dressing -- just the arena tearing apart and snapping
--- back). The real box tears into two pieces that slide apart along an axis (vertical, horizontal, or
--- diagonal), the soul gets pushed along with whichever piece it's on, fire markers burn at the seam,
--- "tooth" bullets spray out along the crack, then the halves slam back together.
---
--- GML reference (obj_knight_split_growtangle Step/Step_2/Draw), faithful timers:
---   con 1 (telegraph): waits `split_wait`(5) frames, then -> con 2 (spawns the tooth bullets here).
---   con 2 (open): `distance` eases OUT 0 -> max_distance(70) over split_hold/2(15) frames
---     (scr_ease_out(t,3)). Then -> con 3.
---   con 3 (close): `distance` eases IN max_distance -> 0 over split_hold/2(15) frames (scr_ease_in(t,3)).
---     Then -> con 4.
---   con 4 (settle): `distance` moves toward 0 at a flat rate of 12/frame; once it hits 0, finished.
---   `diagonal` mode (GML): the box splits along a 45-degree line instead of straight -- the two pieces
---     are TRIANGLES (cut corner-to-corner), separating diagonally instead of purely horizontally/
---     vertically. `vertical` still matters even when diagonal (it picks WHICH diagonal, i.e. which pair
---     of opposite corners).
---@class KnightBoxSplit : Wave
local KnightBoxSplit, super = Class(Wave)

-- Deterministic attack roll: the current wave's private RNG (seeded from the shared defend
-- seed), immune to global-stream drift from local-only effects. Falls back to love.math.
local function ORNG(...)
    local o = Mod.libs and Mod.libs["online"]
    if o and o.atkRandom then return o:atkRandom(...) end
    return love.math.random(...)
end

local SPLIT_WAIT   = 5    -- frames of telegraph before the split begins
local SPLIT_HOLD    = 30   -- open+close duration (split evenly between con 2 and con 3)
local MAX_DISTANCE  = 70   -- GM room-scale half-gap distance; scaled down to Kristal's arena size below
local SCALE         = 0.5  -- Kristal arenas run smaller than GM's box -- scale MAX_DISTANCE down to match
local SETTLE_RATE   = 12 * SCALE
local IND_TIME      = 30   -- frames the rotating slice indicator winds up before the cut (splitslash timer==30)

-- Per-difficulty settings (obj_roaringknight_boxsplitter_attack init + growtangle init). Only d3's
-- spawn_speed survives decompiling (dev comment: "we compromised. it's 39 now") -- the others are
-- sentinel object indices, so they're tuned guesses ordered easy->hard. Non-kaizo damage: d2 155,
-- d5 135, else 206.
--   d0: one random orientation for the WHOLE turn, straight cuts only, cadence accelerates.
--   d1: random straight cuts, cadence accelerates.
--   d2: random straight cuts, faster + tighter hold (26), cadence accelerates.
--   d3: the classic -- straight + DIAGONAL cuts (only difficulty with diagonals), timers tighten.
--   d5: vertical cuts only, wide gap, long hold (50, shrinking), 14 double-wave column bullets.
local DIFF = {
    [0] = { spawn_speed = 48, slashes = 5, hold = 30, damage = 206, max_dist = 70, bullets = 13 },
    [1] = { spawn_speed = 44, slashes = 6, hold = 30, damage = 206, max_dist = 70, bullets = 13 },
    [2] = { spawn_speed = 40, slashes = 6, hold = 26, damage = 155, max_dist = 70, bullets = 13 },
    [3] = { spawn_speed = 39, slashes = 5, hold = 30, damage = 206, max_dist = 70, bullets = 13 },
    [5] = { spawn_speed = 70, slashes = 5, hold = 50, damage = 135, max_dist = 100, bullets = 14 },
}
local SPAWN_FLOOR = 30   -- d<=2 cadence accelerates 3/slash toward this (sentinel; tuned guess)

local function easeOut3(t) return 1 - (1 - t) ^ 3 end
local function easeIn3(t) return t ^ 3 end

function KnightBoxSplit:init()
    super.init(self)
    -- Difficulty (0, 1, 2, 3, 5): variant waves set this (and debug knobs) before calling computeTime.
    self.difficulty = self.difficulty or 3
    self:computeTime()
end

-- N slashes on the manager's cadence, plus the last indicator + split + settle tail. Separate from
-- init so variant waves can set difficulty / hold_open / n_slashes first and recompute.
function KnightBoxSplit:computeTime()
    local d = DIFF[self.difficulty] or DIFF[3]
    local slashes = self.n_slashes or d.slashes
    self.time = (slashes * (d.spawn_speed + (self.hold_open or 0)) + 120) / 30
end

function KnightBoxSplit:onStart()
    -- Arm this wave's private deterministic RNG (every ORNG roll draws from it).
    local _o = Mod.libs and Mod.libs["online"]
    if _o and _o.setWaveRNG then _o:setWaveRNG(self.id or "wave") end

    local arena = Game.battle.arena
    self.arena = arena
    self.old_w, self.old_h = arena.width, arena.height
    self.old_x, self.old_y = arena.x, arena.y
    self.cx, self.cy = arena:getCenter()

    -- Manager state (obj_roaringknight_boxsplitter_attack Step): a new slash telegraph starts every
    -- SPAWN_SPEED frames; each slash winds up its rotating indicator for 30 frames, THEN tears the box
    -- along that line (splitslash timer==30 forces growtangle con=1). Repeats until the turn's over.
    local d = DIFF[self.difficulty] or DIFF[3]
    self.spawn_speed  = d.spawn_speed
    self.n_slashes    = self.n_slashes or d.slashes
    self.split_damage = d.damage
    self.max_distance = d.max_dist
    self.bullet_count = d.bullets

    self.slash_count = 0
    -- GML: manager timer starts at 200 (>= spawn_speed) -> first slash lands IMMEDIATELY, except
    -- difficulty 5 which starts at 52 (first slash after spawn_speed-52 frames).
    self.spawn_timer = (self.difficulty == 5) and 52 or self.spawn_speed
    self.diag_flag = false                          -- d3 diagonal machine (never twice in a row)
    self.force_oneside = ORNG(0, 1)     -- d0: one orientation the whole turn
    self.ind_active = false
    self.ind_timer = 0

    self.con = 0        -- 0 = idle box; 1..4 = the split cycle (telegraph/open/close/settle)
    self.timer = 0
    self.distance = 0
    self.old_distance = 0

    -- These tighten after every completed split (GML con==4: d3 wait->3/hold->26, else hold->30).
    self.split_wait = SPLIT_WAIT
    self.split_hold = d.hold

    -- Fire markers at the seam edges (spr_rk_split_flame_big).
    self.marker_a = self:spawnSprite("bullets/knight/splitflame/big", self.cx, self.cy)
    self.marker_b = self:spawnSprite("bullets/knight/splitflame/big", self.cx, self.cy)
    for _, m in ipairs({ self.marker_a, self.marker_b }) do
        -- Real sprite origin from the metadata: OriginX=37, OriginY=25 on the full 75x50 canvas
        -- (= 0.493, 0.5). Using the full-canvas frames means every frame is the same size, so no
        -- bobbing -- the animation flickers in place around the true anchor point, matching the GML.
        m:setOrigin(37 / 75, 25 / 50)
        m:setScale(1.9, 1.9)   -- GML uses 2x; trimmed slightly to fit Kristal's box
        m:play(1 / 15, true)
        m:setColor(0.6, 0.6, 0.6)
        m.visible = false      -- hidden until a split is actually running
    end
end

-- Start one slash: pick this cut's mode/angle exactly like the manager + splitslash init do, then run
-- the 30-frame rotating indicator (the additive line drawn in KnightBoxSplit:draw()).
function KnightBoxSplit:_startSlash()
    self.slash_count = self.slash_count + 1
    local parity = (self.slash_count % 2) == 1   -- GML reads slash_count AFTER the manager increments it

    -- Manager orientation roll: vertical = irandom(1); d0 = force_oneside (fixed all turn); d5 = always 1.
    local vert_roll = ORNG(0, 1)
    if self.difficulty == 0 then vert_roll = self.force_oneside end
    if self.difficulty == 5 then vert_roll = 1 end

    -- Diagonals are d3-only (GML: uses the current flag, clears it after a diagonal + delays the next
    -- slash 4 frames, else re-rolls -- so never twice in a row).
    -- DISABLED for now: the diagonal piece/fire geometry still looks broken in-game.
    local DIAGONALS_ENABLED = false
    local diagonal = false
    if self.force_diagonal and DIAGONALS_ENABLED then
        diagonal = true
    elseif self.difficulty == 3 and DIAGONALS_ENABLED then
        diagonal = self.diag_flag
        if diagonal then
            self.spawn_timer = -4   -- GML: timer = -4
            self.diag_flag = false
        else
            self.diag_flag = ORNG(0, 1) == 1
        end
    end

    -- d<=2: cadence accelerates 3 frames per slash toward the floor.
    if self.difficulty <= 2 and self.spawn_speed > SPAWN_FLOOR then
        self.spawn_speed = math.max(SPAWN_FLOOR, self.spawn_speed - 3)
    end

    if diagonal then
        -- splitslash init: direction = (slash_count%2==1) ? -45 : 45. GM -45 runs TL->BR, which is our
        -- vertical=false triangle pair, so the flag maps inverted.
        self.next_mode = "diagonal"
        self.next_vertical = not parity
        self.ind_angle = parity and -45 or 45
    elseif vert_roll == 1 then
        self.next_mode = "vertical"
        self.next_vertical = false
        self.ind_angle = parity and -90 or 90
    else
        self.next_mode = "horizontal"
        self.next_vertical = false
        self.ind_angle = 0
    end
    -- angleoffset = random_range(-2, 2); flip = choose(-1, 1) (spin-in direction).
    self.ind_angle = self.ind_angle + (ORNG() * 4 - 2)
    self.ind_flip = ORNG() < 0.5 and -1 or 1

    self.ind_timer = 0
    self.ind_active = true
end

-- The cut lands (splitslash timer==30): force the growtangle into con=1 with the new cut's mode, exactly
-- like the GML does (it doesn't wait for the previous split to finish settling -- it just resets it).
function KnightBoxSplit:_triggerSplit()
    self.distance = 0
    if self.half_a then self.half_a:remove() end
    if self.half_b then self.half_b:remove() end

    self.mode = self.next_mode
    self.vertical = self.next_vertical
    self:_buildHalves()

    -- Hide the REAL arena's visuals while the two decorative halves show (it stays as the collision
    -- boundary underneath) -- otherwise it bridges the two pieces together in the middle.
    self.arena.sprite.visible = false
    -- Diagonal cuts burn a different fire: spr_rk_split_flame_edge (75x50, origin 37,25 -- same
    -- ratios as big), drawn c_gray at 2x pinned to the cut line (GML growtangle Draw).
    local tex = (self.mode == "diagonal") and "bullets/knight/splitflame/edge" or "bullets/knight/splitflame/big"
    for _, m in ipairs({ self.marker_a, self.marker_b }) do
        m:setSprite(tex)
        m:setOrigin(37 / 75, 25 / 50)
        local ms = (self.mode == "diagonal") and 2 or 1.9
        m:setScale(ms, ms)
        m:setColor(self.mode == "diagonal" and 0.5 or 0.6, self.mode == "diagonal" and 0.5 or 0.6,
            self.mode == "diagonal" and 0.5 or 0.6)
        m:play(1 / 15, true)
        m.visible = true
    end

    -- Which piece is the soul on RIGHT NOW? The (invisible) collision arena tracks that piece.
    local soul = Game.battle.soul
    self.soul_side = 1
    if soul then
        if self.mode == "vertical" then
            self.soul_side = (soul.x >= self.cx) and 1 or -1
        elseif self.mode == "horizontal" then
            self.soul_side = (soul.y >= self.cy) and 1 or -1
        else
            local dx, dy = soul.x - self.cx, soul.y - self.cy
            self.soul_side = (dx * self.diag_nx + dy * self.diag_ny >= 0) and 1 or -1
        end
    end

    self.con, self.timer = 1, 0
end

-- Build the two decorative pieces for the chosen mode. Vertical/horizontal are half-size rectangles;
-- diagonal is two triangles (the box cut along one of its diagonals).
function KnightBoxSplit:_buildHalves()
    local arena = self.arena
    local w, h = self.old_w, self.old_h

    if self.mode == "diagonal" then
        -- Cut along one diagonal of the box, chosen by `self.vertical` (reusing that flag the same way
        -- the GML does): true = TL-BR diagonal, false = TR-BL diagonal.
        -- Separation is PERPENDICULAR to the cut, and unnormalized like the GML's heart push
        -- (heart_x/heart_y are +/-1 each, so pieces move `distance` on BOTH axes).
        if self.vertical then
            -- TR-BL cut: TL triangle slides up-left, BR triangle slides down-right.
            self.half_a = Arena(self.cx, self.cy, { { 0, 0 }, { w, 0 }, { 0, h } })       -- TL-TR-BL (top-left triangle)
            self.half_b = Arena(self.cx, self.cy, { { w, 0 }, { w, h }, { 0, h } })       -- TR-BR-BL (bottom-right triangle)
            self.diag_nx, self.diag_ny = 1, 1
        else
            -- TL-BR cut: TR triangle slides up-right, BL triangle slides down-left.
            self.half_a = Arena(self.cx, self.cy, { { 0, 0 }, { w, 0 }, { w, h } })       -- TL-TR-BR (top-right triangle)
            self.half_b = Arena(self.cx, self.cy, { { 0, 0 }, { w, h }, { 0, h } })       -- TL-BR-BL (bottom-left triangle)
            self.diag_nx, self.diag_ny = -1, 1
        end
    elseif self.mode == "vertical" then
        local half_w = w / 2
        self.half_a = Arena(self.cx, self.cy, { { 0, 0 }, { half_w, 0 }, { half_w, h }, { 0, h } })
        self.half_b = Arena(self.cx, self.cy, { { 0, 0 }, { half_w, 0 }, { half_w, h }, { 0, h } })
    else -- horizontal
        local half_h = h / 2
        self.half_a = Arena(self.cx, self.cy, { { 0, 0 }, { w, 0 }, { w, half_h }, { 0, half_h } })
        self.half_b = Arena(self.cx, self.cy, { { 0, 0 }, { w, 0 }, { w, half_h }, { 0, half_h } })
    end

    for _, half in ipairs({ self.half_a, self.half_b }) do
        half.color = arena.color
        half.bg_color = arena.bg_color
        half.line_width = arena.line_width
        half:setShape(half.shape)   -- re-apply so border_line/triangles pick up the copied line_width
        half.layer = arena.layer
        -- Arena:onAdd/onRemove always play the engine's spin/scale-in and shrink-out intro/outro --
        -- these decorative pieces should just appear/disappear instantly, so no-op both.
        half.onAdd = function() end
        half.onRemove = function() end
        Game.battle:addChild(half)
    end

    -- The GML draws each torn piece with the CUT edge (facing the gap) OPEN -- no border line there,
    -- just the flame. Replace each piece's closed border polyline with an OPEN path that omits the
    -- seam edge(s). For diagonal triangles, that's the hypotenuse; for rect halves, one full side.
    local lw = arena.line_width / 2
    if self.mode == "diagonal" then
        if self.vertical then
            -- half_a (TL triangle): keep TL->TR and TL->BL, open the TR-BL hypotenuse.
            self.half_a.border_line = { w - lw, lw,  lw, lw,  lw, h - lw }
            -- half_b (BR triangle): keep TR->BR and BR->BL, open the TR-BL hypotenuse.
            self.half_b.border_line = { w - lw, lw,  w - lw, h - lw,  lw, h - lw }
        else
            -- half_a (TR triangle): keep TL->TR and TR->BR, open the TL-BR hypotenuse.
            self.half_a.border_line = { lw, lw,  w - lw, lw,  w - lw, h - lw }
            -- half_b (BL triangle): keep BR->BL and BL->TL, open the TL-BR hypotenuse.
            self.half_b.border_line = { w - lw, h - lw,  lw, h - lw,  lw, lw }
        end
    elseif self.mode == "vertical" then
        local half_w, half_h = w / 2, h
        -- half_a: open RIGHT edge -> path TR -> TL -> BL -> BR.
        self.half_a.border_line = { half_w - lw, lw,  lw, lw,  lw, half_h - lw,  half_w - lw, half_h - lw }
        -- half_b: open LEFT edge -> path TL -> TR -> BR -> BL.
        self.half_b.border_line = { lw, lw,  half_w - lw, lw,  half_w - lw, half_h - lw,  lw, half_h - lw }
    else -- horizontal
        local half_w, half_h = w, h / 2
        -- half_a: open BOTTOM edge -> path BL -> TL -> TR -> BR.
        self.half_a.border_line = { lw, half_h - lw,  lw, lw,  half_w - lw, lw,  half_w - lw, half_h - lw }
        -- half_b: open TOP edge -> path TL -> BL -> BR -> TR.
        self.half_b.border_line = { lw, lw,  lw, half_h - lw,  half_w - lw, half_h - lw,  half_w - lw, lw }
    end
end

function KnightBoxSplit:_updateHalves()
    local d = self.distance
    local arena = self.arena

    -- Nudge 1px "left" relative to each marker's own orientation: a rotated sprite's local-left is
    -- (-cos, -sin) of its rotation. Applied per marker after positioning so it follows the seam angle.
    local NUDGE = 1
    local function placeMarker(m, x, y, rot)
        m.rotation = rot
        m:setPosition(x - math.cos(rot) * NUDGE, y - math.sin(rot) * NUDGE)
    end

    if self.mode == "vertical" then
        local hw = self.old_w / 4   -- half of a half-arena's width
        self.half_a:setPosition(self.cx - d - hw, self.cy)
        self.half_b:setPosition(self.cx + d + hw, self.cy)
        placeMarker(self.marker_a, self.cx - d, self.cy, -math.pi / 2)
        placeMarker(self.marker_b, self.cx + d, self.cy,  math.pi / 2)

    elseif self.mode == "horizontal" then
        local hh = self.old_h / 4
        self.half_a:setPosition(self.cx, self.cy - d - hh)
        self.half_b:setPosition(self.cx, self.cy + d + hh)
        placeMarker(self.marker_a, self.cx, self.cy - d, math.pi)
        placeMarker(self.marker_b, self.cx, self.cy + d, 0)

    else -- diagonal (GML Draw: _splid = _dist = sqrt(0.5) * distance -- NORMALIZED, so the pieces
         -- move `distance` total, d/sqrt(2) per axis, unlike the straight cuts' full-d single axis).
        local s = d * math.sqrt(0.5)
        local nx, ny = self.diag_nx, self.diag_ny
        self.half_a:setPosition(self.cx - nx * s, self.cy - ny * s)
        self.half_b:setPosition(self.cx + nx * s, self.cy + ny * s)
        -- Fire GML-exact: pinned to the CUT LINE, offset on one axis only, angled along the cut.
        --   GM vertical (our TL-BR cut): (x-s-1, y+2) & (x+s+2, y), angle 135.
        --   GM !vertical (our BL-TR cut): (x+2, y-s-1) angle 230, (x, y+s+2) angle 45.
        if not self.vertical then   -- TL-BR cut (GM diagonal && vertical)
            placeMarker(self.marker_a, self.cx - s - 1, self.cy + 2, -math.rad(135))
            placeMarker(self.marker_b, self.cx + s + 2, self.cy,     -math.rad(135))
        else                        -- BL-TR cut (GM diagonal && !vertical)
            placeMarker(self.marker_a, self.cx + 2, self.cy - s - 1, -math.rad(230))
            placeMarker(self.marker_b, self.cx,     self.cy + s + 2, -math.rad(45))
        end
    end

    -- The real (invisible) collision arena narrows to HALF size and MOVES with whichever piece the soul
    -- started on, so the soul stays confined to it and can't drift into the gap or the other side.
    -- (Diagonal pieces are triangular, but the soul's actual play area is still approximated as the
    -- half-size bounding rectangle on its side of the split -- close enough for a fair, simple clamp.)
    if d > 0.5 then
        if self.mode == "vertical" then
            arena:setSize(self.old_w / 2, self.old_h)
            arena:setPosition(self.old_x + self.soul_side * (d + self.old_w / 4), self.old_y)
        elseif self.mode == "horizontal" then
            arena:setSize(self.old_w, self.old_h / 2)
            arena:setPosition(self.old_x, self.old_y + self.soul_side * (d + self.old_h / 4))
        else
            arena:setSize(self.old_w / 2, self.old_h / 2)
            local s = d * math.sqrt(0.5)
            local nx, ny = self.diag_nx, self.diag_ny
            arena:setPosition(
                self.old_x + self.soul_side * nx * s,
                self.old_y + self.soul_side * ny * s)
        end
    else
        arena:setSize(self.old_w, self.old_h)
        arena:setPosition(self.old_x, self.old_y)
    end
end

-- Spawn the "tooth" split bullets along the seam, following the decompiled GML MECHANICALLY:
--   _total = bullet_count (+1 if odd); _shift = _range / (_total/2 - 1); _flip = choose(true,false) ONCE
--   before the loop. Looping _i = 0 .. bullet_count-1:
--     - at _i == _total/2 EXACTLY: reset the position back to the start (+ half a shift if odd count),
--       reset _weight to the "none" sentinel, and flip `_flip`.
--     - if _weight is the sentinel, re-roll it to one of {-2,-1,1,2}.
--     - _speed = (sign(-_weight) == 1) and 1 or 0   -- i.e. 0 or 1, from the CURRENT _weight.
--     - spawn at the current (x,y) along the seam; friction/top_speed keyed off _speed (1=fast,0=slow).
--     - direction = _flip and (vertical: 180 else 0) or (horizontal: 90 else -90) -- CURRENT _flip.
--       For diagonal, the bullets fire along the diagonal's normal (matching how the halves separate).
--     - weight decay: if abs(_weight)==1, _weight = choose(1,2) * sign(-_weight) (flips sign, new mag
--       1 or 2); else _weight = movetowards(_weight, 0, 1) (steps toward the sentinel).
--     - position += shift (along the seam).
function KnightBoxSplit:_spawnSplitBullets()
    -- Difficulty 5 uses a completely different bullet block (GML _Ytype=1, _waves=2): TWO waves of 14
    -- bullets pinned to the seam's x, spread as a column across the box height, sweeping horizontally
    -- at stepped speeds (wave 0: 10 / 7.5, wave 1: 5 / 2.5, halves firing opposite ways).
    if self.difficulty == 5 then
        -- GM fits 7 rows in a ~300px-tall box (~43px lanes). Kristal's box is about half that,
        -- so 7 rows left ~1px gaps -- a literal wall, four times. Scale the row count to the
        -- real box height instead (one dodge lane every ~36px), keeping 2 bullets per row
        -- (one per direction) and identical lanes across both waves like the GML.
        local h = self.old_h - 8
        local rows = math.max(3, math.floor(h / 36))
        local count = rows * 2
        for wave = 0, 1 do
            local flip = ORNG() < 0.5
            ---@type number?
            local weight = nil
            for i = 0, count - 1 do
                if i == count / 2 then
                    weight = nil
                    flip = not flip
                end
                if weight == nil then
                    weight = ({ -2, -1, 1, 2 })[ORNG(1, 4)]
                end
                local speed_hi = (weight < 0) and 1 or 0
                -- _spd = 10 - 10/4 * ((speed_hi==1 and 0 or 1) + wave*2)
                local spd = 10 - 2.5 * ((speed_hi == 1 and 0 or 1) + wave * 2)
                local by = (self.cy - self.old_h / 2) + 15 + (i % rows) * (h / rows)
                -- GML: friction ramps 0 -> -0.36 over 57f; approximated as a flat -0.18.
                self:spawnBullet("knight_split_bullet", self.cx, by,
                    flip and 180 or 0, spd, -0.18, self.split_damage)
                if math.abs(weight) == 1 then
                    weight = (ORNG() < 0.5 and 1 or 2) * (weight < 0 and 1 or -1)
                else
                    if weight > 0 then weight = math.max(0, weight - 1)
                    else weight = math.min(0, weight + 1) end
                end
            end
        end
        return
    end

    local BULLET_COUNT = self.bullet_count
    local RANGE = 144

    local total = BULLET_COUNT
    local odd = (BULLET_COUNT % 2) == 1
    if odd then total = total + 1 end

    local shift = RANGE / (total / 2 - 1)
    local flip = ORNG() < 0.5

    local pos = -RANGE / 2   -- position along the seam, relative to centre
    ---@type number?
    local weight = nil   -- nil = the GML's "none" sentinel

    local diagonal = (self.mode == "diagonal")
    local dir = 0

    -- Seam direction (along which bullets are spread) and its perpendicular (fire direction).
    -- DIAGONAL is completely different in the GML: every bullet spawns AT THE CENTRE and the direction
    -- just accumulates 360/bullet_count each time -- a full radial fan, no seam line at all.
    local seam_x, seam_y, perp_deg_a, perp_deg_b = 0, 0, 0, 0
    if self.mode == "vertical" then
        seam_x, seam_y = 0, 1
        perp_deg_a, perp_deg_b = 180, 0
    elseif self.mode == "horizontal" then
        seam_x, seam_y = 1, 0
        perp_deg_a, perp_deg_b = 90, -90
    end

    for i = 0, BULLET_COUNT - 1 do
        -- The halfway reset only happens for straight cuts (GML: `(!diagonal) && _i == _total/2`).
        if (not diagonal) and i == math.floor(total / 2) then
            pos = -RANGE / 2
            if odd then pos = pos + shift / 2 end
            weight = nil
            flip = not flip
        end

        if weight == nil then
            weight = ({ -2, -1, 1, 2 })[ORNG(1, 4)]
        end

        local speed_hi = (weight < 0) and 1 or 0   -- sign(-weight)==1 <=> weight<0

        -- top_speed gets a +/-0.12 random wobble in the GML (waves==1 path).
        local top_speed = (speed_hi == 1 and 5 or 2.85) + (ORNG() * 0.24 - 0.12)
        local accel     = speed_hi == 1 and -0.3 or -0.15

        if diagonal then
            dir = dir + 360 / BULLET_COUNT
            self:spawnBullet("knight_split_bullet", self.cx, self.cy, dir, top_speed, accel, self.split_damage)
        else
            local sx, sy = self.cx + seam_x * pos, self.cy + seam_y * pos
            self:spawnBullet("knight_split_bullet", sx, sy, flip and perp_deg_a or perp_deg_b, top_speed, accel, self.split_damage)
        end

        -- Weight decay (GML: abs(weight)==1 -> flip sign, new magnitude 1 or 2; else step toward 0).
        if math.abs(weight) == 1 then
            weight = (ORNG() < 0.5 and 1 or 2) * (weight < 0 and 1 or -1)
        else
            if weight > 0 then weight = math.max(0, weight - 1)
            else weight = math.min(0, weight + 1) end
        end

        pos = pos + shift
    end
end

function KnightBoxSplit:update()
    super.update(self)

    -- Manager cadence: a new slash telegraph every spawn_speed frames until the budget's spent.
    -- (Debug hold_open: don't start the next slash mid-hold, or it'd reset the split we're staring at.)
    if self.slash_count < self.n_slashes
        and not ((self.hold_open or 0) > 0 and (self.con ~= 0 or self.ind_active)) then
        self.spawn_timer = self.spawn_timer + DTMULT
        if self.spawn_timer >= self.spawn_speed then
            self.spawn_timer = self.spawn_timer - self.spawn_speed
            self:_startSlash()
        end
    end

    -- Rotating indicator winding up; at 30 frames the cut lands and the split (re)starts.
    if self.ind_active then
        self.ind_timer = self.ind_timer + DTMULT
        if self.ind_timer >= IND_TIME then
            self.ind_active = false
            -- The cut lands (splitslash timer==30: snd_wideslash_low).
            pcall(function() Assets.playSound("wideslash_low", 0.8, 0.9 + ORNG() * 0.4) end)
            self:_triggerSplit()
        end
    end

    self:_updateSplitCycle()
end

-- The growtangle's con 1-4 split machine. Kept as its own method so other attacks that trigger box
-- splits (quickslash's big slash spawns the same obj_knight_split_growtangle) can reuse it by
-- borrowing these methods at runtime.
function KnightBoxSplit:_updateSplitCycle()
    self.timer = self.timer + DTMULT
    self.old_distance = self.distance

    -- Diagonal splits hold 2 frames longer (GML: _hold = diagonal ? split_hold+2 : split_hold).
    local hold = self.split_hold + (self.mode == "diagonal" and 2 or 0)

    if self.con == 1 then
        if self.timer >= self.split_wait then
            self.con, self.timer = 2, 0
            -- GML growtangle con1->2: snd_knight_boxbreak + snd_chargeshot_fire.
            pcall(function() Assets.playSound("knight_boxbreak", 1, 1.1) end)
            pcall(function() Assets.playSound("chargeshot_fire") end)
            self:_spawnSplitBullets()
        end

    elseif self.con == 2 then
        local t = math.min(1, self.timer / (self.split_hold / 2))
        self.distance = easeOut3(t) * self.max_distance * SCALE
        if self.timer >= hold / 2 then
            -- Debug knob: park fully open for hold_open frames before closing.
            if (self.hold_open or 0) > 0 then
                self.con, self.timer = 2.5, 0
            else
                self.con, self.timer = 3, 0
            end
        end

    elseif self.con == 2.5 then
        self.distance = self.max_distance * SCALE
        if self.timer >= self.hold_open then
            self.con, self.timer = 3, 0
        end

    elseif self.con == 3 then
        local t = math.min(1, self.timer / (self.split_hold / 2))
        self.distance = self.max_distance * SCALE - easeIn3(t) * self.max_distance * SCALE
        if self.timer >= hold / 2 then
            self.con, self.timer = 4, 0
        end

    elseif self.con == 4 then
        self.distance = math.max(0, self.distance - SETTLE_RATE * DTMULT)
        if self.distance <= 0 then
            self.distance = 0
            self.con = 0
            -- Tighten the next cycle's timers (GML con==4): d3 -> wait 3 / hold 26; everyone else
            -- floors at wait 5 / hold 30 (which shrinks d5's long 50 hold back down split by split).
            if self.difficulty == 3 then
                if self.split_wait > 3 then self.split_wait = self.split_wait - 1 end
                if self.split_hold > 26 then self.split_hold = self.split_hold - 2 end
            else
                if self.split_wait > 5 then self.split_wait = self.split_wait - 1 end
                if self.split_hold > 30 then self.split_hold = self.split_hold - 2 end
            end
            pcall(function() Assets.playSound("locker") end)   -- GML: snd_locker on the snap shut
            -- Back to an intact box between cuts: show the real arena again, hide the torn pieces.
            self.arena:setSize(self.old_w, self.old_h)
            self.arena:setPosition(self.old_x, self.old_y)
            self.arena.sprite.visible = true
            if self.half_a then self.half_a.visible = false end
            if self.half_b then self.half_b.visible = false end
            self.marker_a.visible = false
            self.marker_b.visible = false
            self:_splitCycleDone()
        end
    end

    if self.con > 0 then
        self:_updateHalves()
    end
end

-- Hook: a split just finished settling. (Overridden by borrowers like quickslash.)
function KnightBoxSplit:_splitCycleDone()
    if self.slash_count >= self.n_slashes and not self.ind_active then
        self:setFinished()
    end
end

-- The rotating slice indicator (obj_roaringknight_splitslash Draw, the !slash branch): an additive
-- half-tinted line growing 0->1800px long / 40->0px thick (spr_pxwhite10_center is 10x10, xscale
-- ease*180 / yscale lerp(4,0,ease)), spinning from a 15-degree offset into the final cut angle.
function KnightBoxSplit:draw()
    super.draw(self)
    if self.ind_active then
        local ease = easeOut3(math.min(1, self.ind_timer / IND_TIME))
        local spin = (ease * 15 - 15) * self.ind_flip
        local len  = ease * 180 * 10
        local size = (1 - ease) * 4 * 10
        if size > 0.1 and len > 0.1 then
            love.graphics.push("all")
            love.graphics.setBlendMode("add")
            -- merge_color(c_black, 0xFFA286, 0.5): GM colours are BGR, so this is half of RGB(134,162,255).
            Draw.setColor(134 / 255 / 2, 162 / 255 / 2, 0.5, 1)
            love.graphics.translate(self.cx, self.cy)
            love.graphics.rotate(-math.rad(spin + self.ind_angle))
            love.graphics.rectangle("fill", -len / 2, -size / 2, len, size)
            love.graphics.pop()
        end
    end
end

function KnightBoxSplit:onEnd(death)
    if self.arena then
        self.arena:setSize(self.old_w, self.old_h)
        self.arena:setPosition(self.old_x, self.old_y)
        self.arena.sprite.visible = true
    end
    if self.half_a then self.half_a:remove() end
    if self.half_b then self.half_b:remove() end
    super.onEnd(self, death)
end

return KnightBoxSplit
