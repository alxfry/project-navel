local Entity = require "smee.game_core.entity"
local EntityComponent = require "smee.game_core.entitycomponent"
local UnitComponent = require "skoa_sandbox.entitycomponents.unitcomponent"
local EntityDefinitions = require "skoa_sandbox.statics.entitydefinitions"
local Table = require "skoa_sandbox.utl.table"

local BattlefieldComponent = EntityComponent:subclass("BattlefieldComponent")

local PI = 3.14159265359

function BattlefieldComponent:initialize(owner)
    EntityComponent.initialize(self, owner)
    self.units = {}
    self.turnOrder = {}
    self.currentActor = 0

    local resourceImages = SMEE.GetGame().resources.images

    resourceImages["arrowImage"] = resourceImages["arrowImage"] or love.graphics.newImage("/skoa_sandbox/resources/tutorial_arrow.png")
    self.arrowImage = resourceImages["arrowImage"]
    self.arrowOffsetX = self.arrowImage:getWidth() / 2 
    self.arrowOffsetY = self.arrowImage:getHeight()
end

function BattlefieldComponent:init(owner, battlefieldStatics, playerId)
	-- print("BattlefieldComponent:init(" .. tostring(battlefieldStatics) .. ", " .. tostring(playerId) .. ")")

    local entityManager = SMEE.GetGame().entityManager
    self.entityManager = entityManager
    
	-- Instantiate units.
	for i, unitDescription in ipairs(battlefieldStatics.units) do
		local newUnit = Entity.static.createFromEStat(EntityDefinitions[unitDescription.unitId], 1)
		newUnit:initPosition(unitDescription.pos[1], unitDescription.pos[2])
        entityManager:add(newUnit)
		self.units[newUnit.id] = newUnit
        -- Put units into turn order
        local found = false
        for i,candidateId in ipairs(self.turnOrder) do
            local candidate = self.units[candidateId]
            local candidateUnitComponent = candidate:getComponent("UnitComponent")
            local newUnitUnitComponent = newUnit:getComponent("UnitComponent")
            if candidateUnitComponent.initiative < newUnitUnitComponent.initiative then
                table.insert(self.turnOrder, i, newUnit.id)
                found = true
                break
            end
        end
        if not found then
            table.insert(self.turnOrder, newUnit.id)
        end
		-- dbgprint("Added new unit at: " .. Table.dump(unitDescription.pos))
	end
    self:nextUnitRound()
end

function BattlefieldComponent:nextUnitRound()
    self.currentActor = (self.currentActor % #self.turnOrder) + 1
    dbgprint(self.currentActor)
    dbgprint(self.turnOrder[self.currentActor])
    -- TODO: Apply roundbased effects here
end

function BattlefieldComponent:draw(dt)
    local currentUnit = self.units[self.turnOrder[self.currentActor]]
    -- love.graphics.push()
    -- love.graphics.translate(currentUnit.position.x - )
    -- love.graphics.rotate(180)
    -- love.graphics.draw(self.arrowImage, currentUnit.position.x - self.arrowOffsetX, currentUnit.position.y)
    -- love.graphics.origin()
end

function BattlefieldComponent:removeEntity(entity)
    for idx, existingEntity in ipairs(self.units) do
    	if existingEntity.id == entity.id then
    		table:remove(idx)
    		self.entityManager:remove(entity.id)
    	end
    end
end

return BattlefieldComponent