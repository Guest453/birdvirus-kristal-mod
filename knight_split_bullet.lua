--- KnightSplitBullet: DELTARUNE Ch3 obj_roaringknight_split_bullet ("tooth" bullets fired along the
--- seam when the box splits). Spawns inactive, ramps up to full speed, then keeps accelerating outward
--- (negative friction), colour fading peach -> white.
---
--- GML reference (obj_roaringknight_split_bullet Create/Step/Draw + the split spawner):
---   Create: speed_mult=0, top_speed (set by spawner), active=false, distance=0.
---   Step: speed_mult += 0.2 each frame (caps at 1); active once speed_mult >= 0.1; speed = speed_mult*
---     top_speed. The spawner also gives it `friction` (-0.15 or -0.3 -> NEGATIVE = keeps accelerating).
---   Draw: 2-frame anim (ease-in), image_blend fades merge(0xFFA286 peach -> c_white) over ~30 frames,
---     with a tiny +/-0.1 scale jitter. Sprite spr_roaringknight_tooth (36x36, centred).
---   Spawner (obj_knight_split_growtangle): bullet_count=13 spread across bullet_range=144 along the
---     seam, direction perpendicular to the seam (vertical split -> 0/180, horizontal -> 90/-90),
---     top_speed ~5 (fast half) / ~2.85 (slow half), damage 206.
---@class KnightSplitBullet : Bullet
---@overload fun(...) : KnightSplitBullet
local KnightSplitBullet, super = Class(Bullet)

-- GML 0xFFA286 is BGR (GameMaker colour order), so this is actually RGB(134, 162, 255) -- the Knight's
-- light blue, NOT peach.
local PEACH = { 134 / 255, 162 / 255, 1 }

-- dir_deg: travel direction (GM degrees). top_speed: full speed. accel: per-frame friction (negative).
function KnightSplitBullet:init(x, y, dir_deg, top_speed, accel, damage)
    super.init(self, x, y, "bullets/knight/tooth")   -- spr_roaringknight_tooth (36x36)
    self.damage = damage or 206
    self.tp = 3                    -- grazepoints = 3
    self.remove_offscreen = true
    self.destroy_on_hit   = false

    self:setOrigin(0.5, 0.5)
    self:setScale(1, 1)
    -- GML mask (spr_roaringknight_tooth, BBoxMode manual): margins L12 R24 T15 B20 -> a 13x6
    -- core of the 36x36 canvas. The default half-canvas box was ~3x too big ("inaccurate").
    self.collider = Hitbox(self, 12, 15, 13, 6)
    self.rotation = -math.rad(dir_deg)
    self.dir_deg   = dir_deg
    self.top_speed = top_speed or 5
    self.accel     = accel or -0.15   -- negative friction = keeps speeding up

    self.speed_mult = 0
    self.spd = 0
    self.extra = 0                 -- accumulated speed from the negative friction
    self.coltimer = 0

    -- GML: bullets spawn `active = false` (frozen + harmless) and only arm at con2 timer==7,
    -- after the box halves have pushed the souls off the seam. Live-at-spawn was a free hit.
    self.collidable = false
    self.warmup = 7
end

function KnightSplitBullet:update()
    -- Warmup: sit frozen and harmless until armed (GML active=false until con2 timer 7).
    if self.warmup > 0 then
        self.warmup = self.warmup - DTMULT
        if self.warmup <= 0 then
            self.collidable = true
        else
            super.update(self)
            return
        end
    end

    -- Ramp speed_mult 0 -> 1 (+0.2/frame); speed = speed_mult * top_speed, plus the accelerating "extra".
    if self.speed_mult < 1 then
        self.speed_mult = math.min(1, self.speed_mult + 0.2 * DTMULT)
    end
    -- friction<0 keeps adding speed once at full ramp (GML applies friction every step).
    if self.speed_mult >= 1 then
        self.extra = self.extra - self.accel * DTMULT   -- accel is negative, so this grows
    end
    self.spd = self.speed_mult * self.top_speed + self.extra

    local r = math.rad(self.dir_deg)
    self.x = self.x + math.cos(r) * self.spd * DTMULT
    self.y = self.y - math.sin(r) * self.spd * DTMULT

    -- Colour fades peach -> white over ~30 frames.
    self.coltimer = self.coltimer + DTMULT
    local t = math.min(1, self.coltimer / 30)
    self:setColor(PEACH[1] + (1 - PEACH[1]) * t, PEACH[2] + (1 - PEACH[2]) * t, PEACH[3] + (1 - PEACH[3]) * t)

    super.update(self)
end

return KnightSplitBullet
