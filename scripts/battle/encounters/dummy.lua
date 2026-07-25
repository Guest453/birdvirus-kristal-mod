local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Some random bird roars at you."

    -- Battle music ("battle" is rude buster)
    self.music = "titan_spawn"
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("dummy")

end

function Dummy:getDialogueCutscene()
    for _, enemy in ipairs(Game.battle.enemies) do
        if enemy.phase_three_pending and not enemy.phase_three_route then
            return "dummy", "phase_three", enemy
        end

        if enemy.fake_death_pending and not enemy.fake_death_done then
            if enemy.fake_death_type == "noelle_snowgrave" then
                return "dummy", "noelle_snowgrave", enemy
            end

            if enemy.fake_death_type == "noelle_iceshock" then
                return "dummy", "noelle_iceshock", enemy
            end

            return "dummy", "fake_death", enemy
        end

        if enemy.noelle_route and enemy.noelle_iceshock_dialogue_pending then
            return "dummy", "noelle_iceshock_followup", enemy
        end

        if enemy.call_kris_pending then
            return "dummy", "call_kris", enemy
        end
    end
end

local function createEnragedWave(enemy, wave_id)
    local wave = Registry.createWave(wave_id)
    local base_spawn_bullet_to = wave.spawnBulletTo

    wave.snowgrave_attacker = enemy
    wave.snowgrave_damage_bonus = 10
    wave.snowgrave_speed_multiplier = 1.20
    wave.timescale = wave.snowgrave_speed_multiplier

    -- One enraged enemy can own both simultaneous waves. This keeps targeting and
    -- damage scaling intact for bullets spawned by the second wave too.
    wave.getAttackers = function(self)
        return {self.snowgrave_attacker}
    end

    wave.spawnBulletTo = function(self, parent, bullet, ...)
        local spawned = base_spawn_bullet_to(self, parent, bullet, ...)

        if spawned and not spawned.snowgrave_enraged then
            spawned.snowgrave_enraged = true
            spawned.attacker = self.snowgrave_attacker
            spawned.damage = (spawned.damage or ((self.snowgrave_attacker.attack or 0) * 5))
                + self.snowgrave_damage_bonus
            spawned.timescale = (spawned.timescale or 1) * self.snowgrave_speed_multiplier
        end

        return spawned
    end

    return wave
end

local function createOwnedWave(enemy, wave_id)
    local wave = Registry.createWave(wave_id)
    wave.assigned_attacker = enemy
    wave.getAttackers = function(self)
        return {self.assigned_attacker}
    end
    return wave
end

local function createPhaseThreeWave(enemy, wave_id)
    local wave = Registry.createWave(wave_id)
    local base_spawn_bullet_to = wave.spawnBulletTo
    local base_update = wave.update
    local spread_by_wave = {
        virus_explosions = 44,
        virus_cross_explode = 42,
        virus_minigun = 18,
        virus_chase_burst = 24,
        virus_box_hunt = 28,
        knifedance = 34,
        knifedancefast = 38,
        cornerknives = 36,
    }
    local spread = spread_by_wave[wave_id] or 26
    local clone_count_by_wave = {
        knifedance = 1,
        knifedancefast = 1,
        knifedancering = 1,
        virus_minigun = 1,
        virus_chase_burst = 1,
        virus_box_hunt = 1,
        virus_cross_explode = 1,
        virus_explosions = 1,
        knight_boxsplit_rain = 1,
        birddash = 1,
        cornerknives = 1,
    }
    local clone_stride_by_wave = {
        virus_minigun = 6,
        virus_chase_burst = 2,
        virus_box_hunt = 2,
        knight_boxsplit_rain = 3,
        birddash = 2,
    }
    local formation = {
        {forward = -0.35, lateral = -1},
        {forward = -0.35, lateral =  1},
        {forward =  0.85, lateral =  0},
    }

    wave.phase_three_attacker = enemy
    wave.phase_three_pending_bullets = {}
    wave.phase_three_spawn_count = 0
    wave.phase_three_clone_count = clone_count_by_wave[wave_id] or 1
    wave.phase_three_clone_stride = clone_stride_by_wave[wave_id] or 1
    wave.timescale = 1.20
    wave.getAttackers = function(self)
        return {self.phase_three_attacker}
    end

    local function getFormationOffset(source, slot)
        local direction = source.physics and source.physics.direction or source.rotation or 0
        local forward_x, forward_y = math.cos(direction), math.sin(direction)
        local lateral_x, lateral_y = -forward_y, forward_x
        return (forward_x * slot.forward + lateral_x * slot.lateral) * spread,
            (forward_y * slot.forward + lateral_y * slot.lateral) * spread
    end

    local function addClone(self, source, parent, slot)
        if not source.parent then
            return
        end

        local clone = source:clone()
        local clone_update = clone.update
        clone.phase_three_enraged = true
        clone.phase_three_source = source
        clone.phase_three_formation_slot = slot
        clone.attacker = self.phase_three_attacker
        clone.timescale = source.timescale
        local start_x, start_y = getFormationOffset(source, slot)
        clone:move(start_x, start_y)

        -- wave code often configures or manually moves only the returned bullet.
        -- keep each duplicate aligned with that fully configured source bullet.
        clone.update = function(bullet)
            clone_update(bullet)
            local original = bullet.phase_three_source
            if not original or not original.parent then
                bullet:remove()
                return
            end
            local offset_x, offset_y = getFormationOffset(original, bullet.phase_three_formation_slot)
            bullet:setPosition(original.x + offset_x, original.y + offset_y)
            bullet.rotation = original.rotation
            bullet.scale_x = original.scale_x
            bullet.scale_y = original.scale_y
            bullet.collidable = original.collidable
            bullet.visible = original.visible
            bullet.alpha = original.alpha
            bullet.damage = original.damage
            bullet.remove_offscreen = original.remove_offscreen
        end

        base_spawn_bullet_to(self, parent, clone)
    end

    -- duplicate only bullets after the spawning call has finished configuring the
    -- returned instance. timers, arena animation, sounds, and visuals still run once.
    wave.spawnBulletTo = function(self, parent, bullet, ...)
        local spawned = base_spawn_bullet_to(self, parent, bullet, ...)
        if spawned and not spawned.phase_three_enraged then
            spawned.phase_three_enraged = true
            spawned.attacker = self.phase_three_attacker
            spawned.timescale = (spawned.timescale or 1) * 1.20
            self.phase_three_spawn_count = self.phase_three_spawn_count + 1
            if self.phase_three_spawn_count % self.phase_three_clone_stride == 0 then
                table.insert(self.phase_three_pending_bullets,
                    {spawned, parent, self.phase_three_spawn_count})
            end
        end
        return spawned
    end

    local function clonePendingBullets(self)
        local pending = self.phase_three_pending_bullets
        self.phase_three_pending_bullets = {}
        for _, entry in ipairs(pending) do
            if self.phase_three_clone_count == 1 then
                local slot = formation[((entry[3] - 1) % 2) + 1]
                addClone(self, entry[1], entry[2], slot)
            else
                for i = 1, math.min(self.phase_three_clone_count, #formation) do
                    addClone(self, entry[1], entry[2], formation[i])
                end
            end
        end
    end

    wave.update = function(self)
        clonePendingBullets(self)
        base_update(self)
        clonePendingBullets(self)
    end

    return wave
end

function Dummy:getNextWaves()
    local active_enemies = Game.battle:getActiveEnemies()
    for _, enemy in ipairs(active_enemies) do
        if enemy.phase_three_route and enemy.getPhaseThreeWaves then
            local wave_id = enemy:getPhaseThreeWaves()[1]
            return {createPhaseThreeWave(enemy, wave_id)}
        end
    end

    for _, enemy in ipairs(active_enemies) do
        if enemy.snowgrave_route and enemy.getSnowgraveWaves then
            local waves = {}
            for _, wave_id in ipairs(enemy:getSnowgraveWaves()) do
                table.insert(waves, createEnragedWave(enemy, wave_id))
            end
            return waves
        end
    end

    -- Build both attacks explicitly so the dynamically-added support keeps its
    -- own attacker and progression while Birdvirus retains its independent,
    -- no-repeat box-split selection. The box-split wave does not request an
    -- arena size, so Titan Spawn remains the sole arena resize owner.
    for _, enemy in ipairs(active_enemies) do
        if enemy.noelle_route and not enemy.snowgrave_route then
            local waves = {}
            local bird_wave = enemy:selectWave()
            if bird_wave then
                table.insert(waves, createOwnedWave(enemy, bird_wave))
            end

            enemy.titan_support_turn = (enemy.titan_support_turn or 0) + 1
            for _, support in ipairs(active_enemies) do
                if support.birdvirus_iceshock_support and enemy.titan_support_turn % 2 == 1 then
                    local support_wave = support:selectWave()
                    if support_wave then
                        table.insert(waves, createOwnedWave(support, support_wave))
                    end
                end
            end
            return waves
        end
    end

    return super.getNextWaves(self)
end

return Dummy
