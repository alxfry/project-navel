local Entity = require "smee.game_core.entity"
local EntityComponent = require "smee.game_core.entitycomponent"
local UnitComponent = require "sandbox.entitycomponents.unitcomponent"
local EntityDefinitions = require "sandbox.statics.entitydefinitions"
local Table = require "sandbox.utl.table"
local CombatLogic = require "sandbox.combatlogic"

local BattlefieldComponent = EntityComponent:subclass("BattlefieldComponent")

local PI = 3.14159265359
local myTest = 0

function BattlefieldComponent:initialize(owner)
    EntityComponent.initialize(self, owner)
    self.units = {}
    self.turnOrder = {}
    self.actionSequence = {}
    self.currentActor = 0

    local resourceImages = SMEE.GetGame().resources.images

    resourceImages["arrowImage"] = resourceImages["arrowImage"] or love.graphics.newImage("/sandbox/resources/tutorial_arrow.png")
    self.arrowImage = resourceImages["arrowImage"]
    self.arrowHalfWidth = self.arrowImage:getWidth() / 2 
    self.arrowHalfHeight = self.arrowImage:getHeight() / 2
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
            if candidateUnitComponent.current.initiative < newUnitUnitComponent.current.initiative then
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
    self.round = 0
    self:nextUnitRound()
end

function BattlefieldComponent:update(dt)
    for eId, entity in pairs(self.units) do
        local unitCmp = entity:getComponent("UnitComponent")
        if unitCmp.dead == true then
            unitCmp.dead = self.round
            -- TODO: Play death animation or something / revive?
            -- for now just remove
            self:removeEntity(entity)
        end
    end
    -- myTest = myTest + dt
    -- if myTest > 4 then
    --     self:nextUnitRound()
    --     myTest = myTest - 4
    -- end
end

function BattlefieldComponent:nextUnitRound()
    self.currentActor = (self.currentActor % #self.turnOrder) + 1
    self.round = self.round + 1
    dbgprint(self.currentActor)
    dbgprint(self.turnOrder[self.currentActor])
    -- TODO: Apply roundbased effects here
    -- refill AP
    local curActorEntity = self:getCurrentActorEntity()
    if curActorEntity then
        local unitComponent = curActorEntity.componentsMap["UnitComponent"]
        unitComponent.base.actionPts = math.min(unitComponent.current.baseActionPts + unitComponent.base.actionPts, unitComponent.current.maxActionPts)
    end
end

function BattlefieldComponent:draw(dt)
    local currentUnit = self.units[self.turnOrder[self.currentActor]]
    love.graphics.push()
    -- Do weird stuff till the arrow fits
    love.graphics.translate(currentUnit.position.x, currentUnit.position.y)
    love.graphics.rotate(PI)
    love.graphics.scale(0.7)
    love.graphics.translate(-self.arrowHalfWidth, 32)
    love.graphics.draw(self.arrowImage, 0, 0, 0)
    love.graphics.pop()
end

function BattlefieldComponent:removeEntity(entity)
    for idx, entityId in ipairs(self.turnOrder) do
        -- local existingEntity = self.units[entityId]
    	if entityId == entity.id then
    		table.remove(self.turnOrder, idx)
            -- if we kill someone who is in
            -- turn order before current actor
            -- we need to adjust the current actor
            if idx < self.currentActor then
                self.currentActor = self.currentActor - 1
            end
    		self.entityManager:remove(entityId)
            self.units[entityId] = nil
    	end
    end
end

function BattlefieldComponent:getCurrentActorEntity()
    return self.units[self.turnOrder[self.currentActor]]
end

local function validateAction(battlefield, actor)
    return actor == battlefield:getCurrentActorEntity() and #battlefield.actionSequence == 0
end

function BattlefieldComponent:performAction(combatLogicCB, actor, ...)
    if not validateAction(self, actor) then
        return false
    end 
    --TODO: Allow Moving and acting in one action

    combatLogicCB(self.owner, actor, ...)
end

return BattlefieldComponent