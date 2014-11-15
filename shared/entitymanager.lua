local Class = require "shared.middleclass"

local EntityManager = Class "EntityManager"

function EntityManager:initialize()
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
    self.entities[self.nextId] = entity
    entity.id = self.nextId
    self.nextId = self.nextId + 1
end

function EntityManager:remove(id)
    self.entities[id]:delete()
    self.entities[id] = nil
end

return EntityManager