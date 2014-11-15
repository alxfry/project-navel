local Building = require "shared.building"
local LogicCore = require "hymn.logiccore"
local EntityStatics = require "hymn.staticdata.entitystatics"

local function copyTable(dst, src)
    for k,v in pairs(src) do
        if(type(v) == "table") then
            dst[k] = {}
            copyTable(dst[k], v)
        else
            dst[k] = v
        end
    end
    return dst
end

local SpawnPortal = Building:subclass("SpawnPortal")

function SpawnPortal:initialize(entityStatic, player)
    Building.initialize(self, entityStatic, player)
    self:setPlayer(player)
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
    self:setAnimation("images/buildings/" .. self.theme .. "/portal.png", 0.1)
end

function SpawnPortal:addPathPoint(position)
    self.path[#self.path + 1] = position
end

function SpawnPortal:update(dt)
	Building.update(self, dt)
	local entityManager = LogicCore.entityManager
	local dtLastSpawn = self.timeSinceLastSpawn
	dtLastSpawn = dtLastSpawn + dt

	if dtLastSpawn >= 2 then
		-- SPAWN
		local spawn = entityManager:spawnFromEntityStatic(self.spawnEntityStatics, self.player)
		spawn:setPosition(self.position.x, self.position.y)
		self.userPath = {}
		for k, v in pairs(self.path) do
			self.userPath[k] = v:copy()
		end
		if self.path[1] then
			spawn:moveTo(self.path[1].x, self.path[1].y)
		end
		self.timeSinceLastSpawn = dtLastSpawn - 2
	else
		self.timeSinceLastSpawn = dtLastSpawn
	end
end	

function SpawnPortal:clearPath()
    self.path = {}
end

return SpawnPortal