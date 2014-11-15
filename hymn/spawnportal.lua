local Building = require "shared.building"
local SpawnPortal = Building:subclass("SpawnPortal")

function SpawnPortal:initialize(entityStatic, player)
	dbgprint(player)
    Building.initialize(self, entityStatic, player)
    self:setPlayer(player)
    self.path = {}
end

local themes = {
    "frost",
    "lava",
}

function SpawnPortal:setPlayer(player)
    self.theme = themes[player.playerId] or themes[1]
    self:setAnimation("images/buildings/" .. self.theme .. "/portal.png", 0.1)
end

function SpawnPortal:addPathPoint(position)
    self.path[#self.path + 1] = position
end

function SpawnPortal:clearPath()
    self.path = {}
end

return SpawnPortal