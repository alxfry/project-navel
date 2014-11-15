local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"

local EntityManager = Class "EntityManager"

function EntityManager:initialize(logicCore)
    self.logicCore = logicCore
    self.nextId = 1
    self.entities = {}
end

function EntityManager:update(dt)
    for id, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

function EntityManager:draw(dt)
    for id, entity in pairs(self.entities) do
        entity:draw(dt)
    end
end

function EntityManager:spawnFromEntityStatic(entityStatic, player)
    local entityClass = require(entityStatic.classSource)
    local entity = entityClass:new(entityStatic, player)
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
function EntityManager:findClosestEntity(position, filter)
    filter = filter or noOp
    local entities = self.entities
    local closestDist = math.huge
    local closestEntity
    for id, entity in pairs(entities) do
        if filter(entity) then
            local d = GameMath.Vector2.distance(entity.position, position)
            dbgprint(entity.id, d)
            if d < closestDist then
                closestEntity = entity
                closestDist = d
            end
        end
    end
    return closestEntity, closestDist
end

return EntityManager
