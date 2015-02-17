local Class = require "smee.libs.middleclass"

local EntityComponent = Class "EntityComponent"

-- THIS IS THE CONSTRUCTOR
function EntityComponent:initialize(entity)
	self.owner = entity
end

-- THIS GETS CALLED WHEN ALL COMPONENTS HAVE BEEN ADDED TO AN ENTITY
function EntityComponent:init()
end

function EntityComponent:update(dt)
end	

function EntityComponent:draw(dt)
end

return EntityComponent