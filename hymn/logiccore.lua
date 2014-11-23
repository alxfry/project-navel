local Class = require "smee.libs.middleclass"

local Game 			= require "smee.game_core.game"
local EntityManager = require "smee.game_core.layeredentitymanager"
local Entity        = require "smee.game_core.entity"
local MapLoader     = require "smee.resource_management.maploader"

local InputHandler  = require "hymn.inputhandler"
local HymnPlayer    = require "hymn.hymnplayer"
local EntityStatics = require "hymn.staticdata.entitystatics"


local function spawn(self, object, x, y)
	local entityManager = self.entityManager
    local entity
    if object.id == 0 then
        entity = Entity.createFromEStat(EntityStatics.deposit)
    elseif object.id == 1 then
    	entity = Entity.createFromEStat(EntityStatics.spawnPortal, 1)
        entity:instantBuild()
    elseif object.id == 2 then
    	entity = Entity.createFromEStat(EntityStatics.spawnPortal, 2)
        entity:instantBuild()
    end

    if entity then
        entityManager:add(entity, self.layerId.buildings)
        entity:setPosition(x, y)
    end
end

local function isPlayer1Entity(self, entity)
    if entity.playerId == 1 then
        return true
    else
        return false
    end
end

local function isPlayer2Entity(entity)
    if entity.playerId == 2 then
        return true
    else
        return false
    end
end

-- LogicCore Class
local HymnGame = Game:subclass("HymnGame")

function HymnGame:initialize(eMng, iHndlr)
	self.state = "init"
	self.map = false
end

function HymnGame:load(mapName)
	Game.load(self)
	self.map = MapLoader:new(mapName, spawn)
end

function HymnGame:init(eMng, iHndlr)
	Game.init(self)

	local player1 = HymnPlayer:new()
	local player2 = HymnPlayer:new()
	self.players = {
		[player1.playerId] = player1,
		[player2.playerId] = player2,
	}

    drawLayer = {
        buildings = "bldgs",
        units = "units"
    }
    self.layerId = drawLayer
	-- TODO: Create and include map component
	self.entityManager = eMng or EntityManager:new(self)
    self.entityManager:addLayer(drawLayer.buildings)
    self.entityManager:addLayer(drawLayer.units)
	self:addComponent(self.entityManager)
	self.inputHandler = iHndlr or InputHandler:new(self)
	-- self:addComponent(self.inputHandler)
	self.state = "running"

	self:startMap(self.map)
end

function HymnGame:update(dt)
	Game.update(self, dt)
    if self.state == "running" then
        -- self.entityManager:update(dt)
        --TODO: make this component
        self.inputHandler:update(dt, self.map)
        self.map:update(dt)

        local playerEntities = self.entityManager:findAllEntities(isPlayer2Entity)
        if #playerEntities == 0 then
            dbgprint("PLAYER WINS")
            self.state = "gameover"
        end
    elseif self.state == "gameover" then
    end
end

function HymnGame:draw(dt)
	-- FIX THIS CODE WITH MAP COMPONENT
    local width, height = love.graphics.getDimensions()

    -- draw map
    local translation = self.inputHandler.translate
    love.graphics.translate(translation.x, translation.y)
    -- Draw Range culls unnecessary tiles
    self.map:setDrawRange(translation.x, translation.y, width, height)
    self.map:draw()

	Game.draw(self, dt)

    -- debug printing the entity paths
    if DEBUG then
    	require "smee.logic.blocking":draw()
	    for id, entity in pairs(self.entityManager.entities) do
	        if entity.drawPath then
	            entity:drawPath()
	        end
	    end
	end

    love.graphics.translate(-translation.x, -translation.y)
end

function HymnGame:startMap(map)
    self.map = map.map
    if map.objects then
    	for i = 1, #map.objects do
    		local obj = map.objects[i]
    		spawn(self, obj.id, obj.x, obj.y)
    	end
    end
    -- ### ADD DEBUG SPAWNS HERE
    spawn(self, {id = 2}, 100, 400)
end

function HymnGame:reset()

end

-- LogicCore Singleton
local hymnGame = HymnGame:new()

return hymnGame

