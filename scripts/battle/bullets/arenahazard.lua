local ArenaHazard, super = Class(Bullet)

function ArenaHazard:init(x, y, rot)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/arenahazard")

    -- Top-center origin point (will be rotated around it)
    self:setOrigin(0.5, 0)

    -- Battle bullets use colliders directly in this Kristal version.
    self.collider = Hitbox(self, 3, 1, math.max(1, self.width - 6), 6)
    self.damage = 20

    -- Rotation of the bullet (in radians)
    self.rotation = rot

    -- Don't destroy this bullet when it damages the player
    self.destroy_on_hit = false
end

function ArenaHazard:getDamage()
    local damage = super.getDamage(self)
    if self.attacker and self.attacker.scaleDamage then
        return self.attacker:scaleDamage(damage)
    end
    return damage
end

function ArenaHazard:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return ArenaHazard
