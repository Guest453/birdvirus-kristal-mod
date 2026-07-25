local FloweryGMLBase, super = Class(Wave)

-- Direct translation of obj_dbulletcontroller types 620-641 and 647.
-- GameMaker's 640x240 scrolling field is mapped into Kristal's 300x190 arena;
-- counters, difficulty numbers, sine formulas, and variant flags stay the same.
local CONFIGS = {
    [620] = {kind = "jarona", difficulty = 0, attack_speed = 20},
    [621] = {kind = "jarona", difficulty = 1, attack_speed = 26},
    [622] = {kind = "jarona", difficulty = 2, attack_speed = 36, do_bullets = true},
    [623] = {kind = "chase", difficulty = 0, timer = 20},
    [624] = {kind = "chase", difficulty = 1, timer = -12},
    [625] = {kind = "chase", difficulty = 2, timer = -5},
    [626] = {kind = "chase", difficulty = 3, timer = -5},
    [627] = {kind = "fists", difficulty = 0, jarona_mode = 1},
    [628] = {kind = "fists", difficulty = 1, jarona_mode = 1, orange_dopple = true},
    [629] = {kind = "fists", difficulty = 2, jarona_mode = 3},
    [630] = {kind = "boxes", difficulty = 0, timer = 20},
    [631] = {kind = "boxes", difficulty = 1, timer = 20},
    [632] = {kind = "chase", difficulty = 4},
    [633] = {kind = "chase", difficulty = 5, timer = 0},
    [634] = {kind = "jarona", difficulty = 1, attack_speed = 26, do_bullets = true},
    [635] = {kind = "chase", difficulty = 6, timer = -12},
    [636] = {kind = "jarona", difficulty = 0, attack_speed = 26, orange_dopple = true},
    [637] = {kind = "chase", difficulty = 7, timer = 0},
    [638] = {kind = "jarona", difficulty = 0, attack_speed = 26, orange_dopple = true, just_kidding = true},
    [639] = {kind = "chase", difficulty = 8, jarona_mode = 4, attack_speed = 24},
    [640] = {kind = "chase", difficulty = 9},
    [641] = {kind = "chase", difficulty = 10, timer = 5, timer_goal = 28},
    [647] = {kind = "chase", difficulty = 12, timer = 5, timer_goal = 30, rotate_control = true},
}

local Y_SCALE = 190 / 240

function FloweryGMLBase:init(attack_id)
    super.init(self)
    self.attack_id = attack_id or self.attack_id or 620
    self.config = CONFIGS[self.attack_id]
    self.time = (self.attack_id == 637 or self.attack_id == 639) and 10 or 8
    self:setArenaSize(300, 190)
    self.frame = self.config.timer or 0
    self.last_frame = math.floor(self.frame)
    self.wall_counter = 0
    self.next_spawn = math.max(1, self.frame)
    self.charge_frames = 0
    self.dash_frames = 0
    self.was_charging = false
end

function FloweryGMLBase:onStart()
    local arena = Game.battle.arena
    if arena.setSize then arena:setSize(300, 190) end
    self.old_soul_speed = Game.battle.soul.speed
    self.old_allow_focus = Game.battle.soul.allow_focus
    Game.battle.soul.allow_focus = false
    Game.battle.soul.speed = 4.5
    if Game.battle.soul.sprite then
        Game.battle.soul.sprite:setColor(1, 0.55, 0)
    end

    if self.config.kind == "jarona" then
        self:spawnJarona()
        self.next_spawn = 92
    elseif self.config.kind == "fists" then
        self:spawnJarona(self.config.jarona_mode)
        self.next_spawn = 32
    elseif self.config.kind == "boxes" then
        self.next_spawn = 20
    elseif self.config.difficulty == 8 then
        self:spawnSuperJaronaWalls()
        self.next_spawn = 150
    elseif self.config.difficulty == 9 then
        self:spawnBlueStars()
        self.next_spawn = 9999
    else
        self.next_spawn = math.max(1, self.config.timer_goal or 6)
    end
end

function FloweryGMLBase:arenaCenter()
    local arena = Game.battle.arena
    return (arena.left + arena.right) / 2, (arena.top + arena.bottom) / 2
end

function FloweryGMLBase:spawnWall(center_y, gap, x_offset, bullet_lines)
    local arena = Game.battle.arena
    center_y = center_y or ((arena.top + arena.bottom) / 2)
    gap = math.max(24, (gap or 120) * Y_SCALE)
    local gap_top = center_y - gap / 2
    local gap_bottom = center_y + gap / 2
    local top_height = math.max(0, gap_top - arena.top)
    local bottom_height = math.max(0, arena.bottom - gap_bottom)
    local x = arena.right + 28 + (x_offset or 0) * 0.47

    if top_height > 2 then
        self:spawnBullet("flowery_gml_wall", x, arena.top + top_height / 2, 12, top_height, 7.52, bullet_lines)
    end
    if bottom_height > 2 then
        self:spawnBullet("flowery_gml_wall", x, gap_bottom + bottom_height / 2, 12, bottom_height, 7.52, bullet_lines)
    end
end

function FloweryGMLBase:spawnJarona(mode)
    local arena = Game.battle.arena
    local _, cy = self:arenaCenter()
    local y = cy
    if mode == 1 then y = cy + ((self.wall_counter % 3) - 1) * 42 end
    self:spawnBullet("flowery_gml_jarona", arena.right + 48, y, self.config.attack_speed or 20, mode or self.config.jarona_mode or 0, self.config.difficulty)
end

function FloweryGMLBase:spawnFistBullets()
    local arena = Game.battle.arena
    local _, cy = self:arenaCenter()
    local count = 3 + self.config.difficulty
    for i = 1, count do
        local y = cy + (i - (count + 1) / 2) * 34
        self:spawnBullet("flowery_orb", arena.left - 20, y, 0, 5.2, i + self.wall_counter, 0)
    end
end

function FloweryGMLBase:spawnBoxWords()
    local arena = Game.battle.arena
    local direction = (self.wall_counter % 2 == 0) and 1 or -1
    local count = self.config.difficulty == 0 and 1 or 2
    local safe_y = arena.top + 30 + love.math.random() * (arena.height - 60)
    for column = 1, count do
        local x = arena.right + 25 + column * 34
        for row = 1, 6 do
            local y = arena.top + (row - 0.5) * arena.height / 6
            if math.abs(y - safe_y) > 24 then
                self:spawnBullet("flowery_orb", x, y, math.pi, 5.1 + self.config.difficulty, row + column, 0)
            end
        end
        direction = -direction
    end
end

function FloweryGMLBase:spawnBlueStars()
    local arena = Game.battle.arena
    local _, cy = self:arenaCenter()
    for i = 0, 15 do
        local x = arena.left + (arena.width / 16) * i
        self:spawnBullet("flowery_gml_sine", x, cy, i * 0.35, false)
        self:spawnBullet("flowery_gml_sine", x, cy, i * 0.35, true)
    end
end

function FloweryGMLBase:spawnAquaKnives()
    local arena = Game.battle.arena
    local _, cy = self:arenaCenter()
    local vertical = (self.wall_counter % 2 == 0) and 1 or -1
    for column = -1, 1, 2 do
        local x = arena.right + 26 + column * 28
        for row = 0, 4 do
            local y = cy - 150 * Y_SCALE + row * 75 * Y_SCALE + (column > 0 and 30 or 0)
            local knife = self:spawnBullet("chargedknife", x, y, vertical > 0 and math.pi / 2 or -math.pi / 2, 0.28, 10)
            knife:setScale(0.55)
        end
    end
end

function FloweryGMLBase:spawnOrbitStars()
    local arena = Game.battle.arena
    local _, cy = self:arenaCenter()
    for i = 0, 7 do
        self:spawnBullet("flowery_gml_orbit", arena.right + 32, cy, math.pi / 4 * i, 5.2)
    end
end

function FloweryGMLBase:spawnSuperJaronaWalls()
    local _, cy = self:arenaCenter()
    local add = 640
    local gap = 140
    local offset = 0
    for i = 0, 8 do
        local center = cy + (((i % 2 == 0) and 1 or -1) * 60 * (1 - i * 0.1) + math.sin(i) * 15) * Y_SCALE
        self:spawnWall(center, gap, offset, false)
        offset = offset + add
        add = math.max(290, add - 140)
        gap = math.max(36, gap - 30)
    end
end

function FloweryGMLBase:stepChase(frame)
    local difficulty = self.config.difficulty
    local _, cy = self:arenaCenter()

    if difficulty == 0 and frame >= self.next_spawn then
        local gap = self.wall_counter < 3 and 120 or (self.wall_counter >= 11 and 50 or 80)
        local center = cy + math.sin(frame * 0.1) * (self.wall_counter < 3 and 24 or 36)
        self:spawnWall(center, gap)
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + (self.wall_counter % 4 == 0 and 26 or 18)
    elseif difficulty == 1 and frame >= self.next_spawn then
        local first_half = self.wall_counter % 10 < 5
        local center = cy + math.sin(frame * 0.24) * 24 + math.cos(frame * 0.035) * 32
        if not first_half then center = cy - (center - cy) end
        self:spawnWall(center, first_half and 80 or 60)
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + 6
    elseif (difficulty == 2 or difficulty == 3) and frame >= self.next_spawn then
        local center = cy + math.sin(frame * 0.1 + self.wall_counter) * 32 + math.cos(frame * 0.0175) * 16
        self:spawnWall(center, difficulty == 2 and 55 or 45)
        self.wall_counter = self.wall_counter + 1
        local group = difficulty == 2 and 8 or 6
        self.next_spawn = frame + (self.wall_counter % group == 0 and 30 or 6)
    elseif difficulty == 4 and frame >= self.next_spawn then
        local center = cy + math.sin(frame * 0.48) * 24 + math.sin(frame * 0.07) * 32
        local cactus = self.wall_counter % 4 == 3
        self:spawnWall(center, cactus and 60 or 52)
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + (cactus and 14 or 5)
    elseif difficulty == 5 and frame >= self.next_spawn then
        local center = cy + math.sin(frame * 0.1) * 32
        self:spawnWall(center, 160, 0, true)
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + (self.wall_counter % 3 == 0 and 46 or 8)
    elseif difficulty == 6 and frame >= self.next_spawn then
        local center = cy + math.sin(frame * 0.96 * 4) * 32 + math.cos(frame * 0.14 * 4) * 32
        self:spawnWall(center, 100)
        if self.wall_counter % 5 == 0 then
            for i = 0, 7 do
                self:spawnBullet("flowery_orb", Game.battle.arena.right + 15, center, math.pi + i * math.pi / 4, 4.5, i + 1, 0.004)
            end
        end
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + (self.wall_counter % 4 == 0 and 25 or 6)
    elseif difficulty == 7 and frame >= self.next_spawn then
        local sequence = {
            {240, 240}, {180, 120}, {60, 120}, {120, 80},
        }
        local item = sequence[(self.wall_counter % #sequence) + 1]
        self:spawnWall(cy, item[2])
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + 30
    elseif difficulty == 8 and frame >= self.next_spawn then
        self:spawnJarona(4)
        self.next_spawn = frame + 100
    elseif difficulty == 10 and frame >= self.next_spawn then
        self:spawnAquaKnives()
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + 28
    elseif difficulty == 12 and frame >= self.next_spawn then
        self:spawnOrbitStars()
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + 30
    end
end

function FloweryGMLBase:updateOrangeHeart()
    local soul = Game.battle and Game.battle.soul
    if not soul then return end

    if Input.down("cancel") then
        self.charge_frames = math.min(30, self.charge_frames + DTMULT)
        self.was_charging = true
        soul.speed = 2.2
        soul.flowery_dashing = false
        if soul.sprite then soul.sprite:setColor(1, 0.8, 0.1) end
    else
        if self.was_charging and self.charge_frames >= 5 then
            self.dash_frames = 5 + math.floor(self.charge_frames * 0.35)
            Assets.playSound("snd_flowery_power_up", 0.22)
        end
        self.was_charging = false
        self.charge_frames = 0
        if self.dash_frames > 0 then
            self.dash_frames = self.dash_frames - DTMULT
            soul.speed = 9
            soul.flowery_dashing = true
            if soul.sprite then soul.sprite:setColor(1, 1, 0.25) end
        else
            soul.speed = 4.5
            soul.flowery_dashing = false
            if soul.sprite then soul.sprite:setColor(1, 0.55, 0) end
        end
    end
end

function FloweryGMLBase:update()
    self:updateOrangeHeart()
    self.frame = self.frame + DTMULT
    local frame = math.floor(self.frame)

    if self.config.kind == "chase" then
        self:stepChase(frame)
    elseif self.config.kind == "jarona" and frame >= self.next_spawn then
        self:spawnJarona()
        if self.config.do_bullets then self:spawnFistBullets() end
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + math.max(64, 104 - (self.config.attack_speed or 20))
    elseif self.config.kind == "fists" and frame >= self.next_spawn then
        self:spawnFistBullets()
        if self.wall_counter % 2 == 1 then self:spawnJarona(self.config.jarona_mode) end
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + (self.config.difficulty == 2 and 20 or 28)
    elseif self.config.kind == "boxes" and frame >= self.next_spawn then
        self:spawnBoxWords()
        self.wall_counter = self.wall_counter + 1
        self.next_spawn = frame + (self.config.difficulty == 0 and 24 or 20)
    end

    self.last_frame = frame
    super.update(self)
end

function FloweryGMLBase:onEnd(death)
    local soul = Game.battle and Game.battle.soul
    if soul then
        soul.speed = self.old_soul_speed or 4
        soul.allow_focus = self.old_allow_focus ~= false
        soul.flowery_dashing = nil
        if soul.sprite then soul.sprite:setColor(1, 0, 0) end
    end
    super.onEnd(self, death)
end

return FloweryGMLBase
