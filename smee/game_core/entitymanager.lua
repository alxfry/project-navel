local Class         = require "smee.libs.middleclass"
local Game          = require "smee.game_core.game"
local GameComponent = require "smee.game_core.gamecomponent"
local GameMath      = require "smee.logic.gamemath"
local Building      = require "shared.building"
local Unit          = require "shared.unit"

local EntityManager = GameComponent:subclass("EntityManager")

function EntityManager:initialize(logicCore)
    self.logicCore = logicCore
    self.nextId = 1
    self.entities = {}
end

function EntityManager:update(dt)
    GameComponent.update(self, dt)

    for id, entity in pairs(self.entities) do
        entity:update(dt)
        if entity.markedForDelete then
            self:prot_delete(entity.id)
        end
    end
end

function EntityManager:draw(dt)
    GameComponent.update(self, dt)

    for eId, entity in pairs(self.entities) do
        entity:draw(dt)
    end
end

function EntityManager:spawnFromEntityStatic(entityStatic, playerId)
    local entityClass = require(entityStatic.classSource)
    local entity = entityClass:new(entityStatic, playerId)
    self:add(entity)
    return entity
end

function EntityManager:add(entity)
    local id = self.nextId
    self.nextId = id + 1

    entity.id = id
    self.entities[id] = entity
end

function EntityManager:remove(id)
    assert(self.entities[id], "Entity Id not found in EntityManager")
    self.entities[id].markedForDelete = true
end

function EntityManager:prot_delete(id)
    local entity = self.entities[id]
    if self.entities[id] then
        self.entities[id]:delete()
        self.entities[id] = nil
    end
end

function EntityManager:entity(id)
    return self.entities[id]
end

local function noOp()
    return true
end

-- position: vector2
-- filter: [optional] filter function(entity)
function EntityManager:findClosestEntity(position, filter, radius)
    radius = radius or math.huge
    filter = filter or noOp
    local entities = self.entities
    local closestDist = math.huge
    local closestEntity
    for id, entity in pairs(entities) do
        if filter(entity) then
            local d = GameMath.Vector2.distance(entity.position, position)
            if d < closestDist and d < radius then
                closestEntity = entity
                closestDist = d
            end
        end
    end
    return closestEntity, closestDist
end

function EntityManager:findAllEntities(filter)
    local entities = {}
    for id, entity in pairs(self.entities) do
        if filter(entity) then
            table.insert(entities, entity)
        end
    end
    return entities
end

function EntityManager:clear()
    for id, entity in pairs(self.entities) do
        delete(self, id)
    end
end

return EntityManager