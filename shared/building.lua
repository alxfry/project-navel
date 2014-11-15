local Entity = require "shared.entity"
local Building = Entity:subclass("Building")

function Building:initialize()
    Entity.initialize(self)
end

function Building:update(dt)
    Entity.update(self, dt)
end

return Building
