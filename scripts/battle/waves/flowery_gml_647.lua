local FloweryGML647, super = Class(Wave)

function FloweryGML647:init()
    local Base = Registry.getWave("flowery_gml_base")
    Base.init(self, 647)
    for _, method in ipairs({
        "onStart", "arenaCenter", "spawnWall", "spawnJarona", "spawnFistBullets", "spawnBoxWords", "spawnBlueStars", "spawnAquaKnives", "spawnOrbitStars", "spawnSuperJaronaWalls", "stepChase", "updateOrangeHeart", "update", "onEnd"
    }) do
        self[method] = Base[method]
    end
end

return FloweryGML647
