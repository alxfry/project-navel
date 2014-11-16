local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"
local Building = require "shared.building"
local Unit     = require "shared.unit"

local EntityManager = Class "EntityManager"

function EntityManager:initialize(logicCore)
    self.logicCore = logicCore
    self.nextId = 1
    self.entities = {}
    self.drawLayer = {
        buildings = {},
        units = {},
    }
end

function EntityManager:update(dt)
    for id, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

function EntityManager:draw(dt)
    local buildings = self.drawLayer.buildings
    local units = self.drawLayer.units
    for i = 1, #buildings do
        local current = buildings[i]
        current:draw(dt)
    end
    for i = 1, #units do
        local current = units[i]
        current:draw(dt)
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
    if entity:isInstanceOf(Building) then
        table.insert(self.drawLayer.buildings, entity)
    elseif entity:isInstanceOf(Unit) then
        table.insert(self.drawLayer.units, entity)
    end
end

function EntityManager:remove(id)
    local entity = self.entities[id]
    if self.entities[id] then
        self.entities[id]:delete()
        self.entities[id] = nil
    end
    if entity:isInstanceOf(Building) then
        for i, entity in pairs(self.drawLayer.buildings) do
            if entity.id == id then
                table.remove(self.drawLayer.buildings, i)
                break
            end
        end
    elseif entity:isInstanceOf(Unit) then
        for i, entity in pairs(self.drawLayer.units) do
            if entity.id == id then
                table.remove(self.drawLayer.units, i)
                break
            end
        end
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
        self:remove(id)
    end
end

return EntityManager
