local Class = require "smee.libs.middleclass"

local EntityComponent = Class "EntityComponent"

function EntityComponent:initialize(entity)
	self.owner = entity
end

function EntityComponent:init()
end

function EntityComponent:update(dt)
end	

function EntityComponent:draw(dt)
end

return EntityComponent