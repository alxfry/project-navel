local EntityComponent = require "smee.game_core.entitycomponent"

local LogicComponent = EntityComponent:subclass("LogicComponent")

function LogicComponent:init()
    self.health = 100
    self.maxHealth = 100
end

function LogicComponent:update(dt)
end

function LogicComponent:draw(dt)
    -- This will probably stay empty
end
