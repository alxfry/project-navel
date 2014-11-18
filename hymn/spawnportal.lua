local Entity 		= require "smee.game_core.entity"

local Building  	= require "shared.building"

local LogicCore 	= require "hymn.logiccore"
local EntityStatics = require "hymn.staticdata.entitystatics"


local SpawnPortal = Building:subclass("SpawnPortal")

function SpawnPortal:initialize(entityStatic, playerId)
    Building.initialize(self, entityStatic, playerId)
    self:setPlayer(playerId)
    self:setAnimation("images/buildings/constructionsite.png", 1)
    self.timeSinceLastSpawn = 0
    self.path = {}
end

function SpawnPortal:setPlayer(playerId)
	self.playerId = playerId
	local player = LogicCore.players[playerId]
    self.theme = player:theme()
    -- self:setAnimation("images/buildings/" .. self.theme .. "/portal.png", 0.1)
end

function SpawnPortal:addPathPoint(position)
    self.path[#self.path + 1] = position
end

function SpawnPortal:spawnInterval()
	local player = LogicCore.players[self.playerId]
    return 800/player.resource
end

function SpawnPortal:update(dt)
	Building.update(self, dt)
	if not self.constructing then
		local entityManager = LogicCore.entityManager
		self.timeSinceLastSpawn = self.timeSinceLastSpawn + dt
        local spawnInterval = self:spawnInterval()
		
		if self.timeSinceLastSpawn >= spawnInterval then --not self.hasSpawned and 
			-- SPAWN
			local spawn = Entity.createFromEStat(self.spawnEntityStatics, self.playerId)
			entityManager:add(spawn, LogicCore.layerId.units)
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