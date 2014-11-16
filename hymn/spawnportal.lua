local Building = require "shared.building"
local LogicCore = require "hymn.logiccore"
local EntityStatics = require "hymn.staticdata.entitystatics"


local SpawnPortal = Building:subclass("SpawnPortal")

function SpawnPortal:initialize(entityStatic, player)
    Building.initialize(self, entityStatic, player)
    self:setPlayer(player)
    self:setAnimation("images/buildings/constructionsite.png", 1)
    self.timeSinceLastSpawn = 0
    self.path = {}
end

local themes = {
    "frost",
    "lava",
}

function SpawnPortal:setPlayer(player)
	self.player = player
    self.theme = themes[player.playerId] or themes[1]
    -- self:setAnimation("images/buildings/" .. self.theme .. "/portal.png", 0.1)
end

function SpawnPortal:addPathPoint(position)
    self.path[#self.path + 1] = position
end

function SpawnPortal:spawnInterval()
    return self.player.resource / 100
end

function SpawnPortal:update(dt)
	local wasConstructing = self.constructing
	Building.update(self, dt)
	if not self.constructing then
		if wasConstructing then
			self:setAnimation("images/buildings/" .. self.theme .. "/portal.png", 0.1)
		end
		local entityManager = LogicCore.entityManager
		self.timeSinceLastSpawn = self.timeSinceLastSpawn + dt
        local spawnInterval = self:spawnInterval()
		
		if self.timeSinceLastSpawn >= spawnInterval then
			-- SPAWN
			local spawn = entityManager:spawnFromEntityStatic(self.spawnEntityStatics, self.player)
			spawn:setPosition(self.position.x, self.position.y)
			spawn.userPath = {}
			for k, v in pairs(self.path) do
				spawn.userPath[k] = v:copy()
			end
			self.timeSinceLastSpawn = self.timeSinceLastSpawn - spawnInterval
	        self.hasSpawned = true
		end
	end
end	

function SpawnPortal:clearPath()
    self.path = {}
end

return SpawnPortal