local Entity = require "shared.entity"
local Building = Entity:subclass("Building")

function Building:initialize(entityStatic, player)
    Entity.initialize(self, entityStatic, player)
end

function Building:update(dt)
    Entity.update(self, dt)
end

return Building
