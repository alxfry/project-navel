local Building = require "shared.building"
local SpawnPortal = Building:subclass("SpawnPortal")

function SpawnPortal:initialize()
    Building.initialize(self)
end

local themes = {
    "frost",
    "lava",
}

function SpawnPortal:setPlayer(player)
    Building:setPlayer(player)
    self.theme = themes[player.playerId] or themes[1]
    self:setAnimation("images/buildings/" .. self.theme .. "/portal.png", 126, 126, 0.1)
end

return SpawnPortal