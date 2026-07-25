local FloweryGML621, super = Class(Wave)

function FloweryGML621:init()
    local Base = Registry.getWave("flowery_gml_base")
    Base.init(self, 621)
    for _, method in ipairs({
        "onStart", "arenaCenter", "spawnWall", "spawnJarona", "spawnFistBullets", "spawnBoxWords", "spawnBlueStars", "spawnAquaKnives", "spawnOrbitStars", "spawnSuperJaronaWalls", "stepChase", "updateOrangeHeart", "update", "onEnd"
    }) do
        self[method] = Base[method]
    end
end

return FloweryGML621
