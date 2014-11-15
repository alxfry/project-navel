local Class = require "shared.middleclass"

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

function EntityManager:add(entity)
    local id = self.nextId
    self.nextId = id + 1

    entity.id = id
    self.entities[id] = entity
end

function EntityManager:remove(id)
    self.entities[id]:delete()
    self.entities[id] = nil
end

function EntityManager:entity(id)
    return self.entities[id]
end

return EntityManager
