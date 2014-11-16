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

function SpawnPortal:setPlayer(player)
	self.player = player
    self.theme = player:theme()
    -- self:setAnimation("images/buildings/" .. self.theme .. "/portal.png", 0.1)
end

function SpawnPortal:addPathPoint(position)
    self.path[#self.path + 1] = position
end

function SpawnPortal:spawnInterval()
    return 800/self.player.resource
end

function SpawnPortal:update(dt)
	Building.update(self, dt)
	if not self.constructing then
		local entityManager = LogicCore.entityManager
		self.timeSinceLastSpawn = self.timeSinceLastSpawn + dt
        local spawnInterval = self:spawnInterval()
		
		if self.timeSinceLastSpawn >= spawnInterval then --not self.hasSpawned and 
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