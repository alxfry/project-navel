local Class = require "smee.libs.middleclass"

local GameComponent = require "smee.game_core.gamecomponent"

local Game = Class "Game"

-- CLASS CONSTRUCTOR
function Game:initialize()
	-- a list of game components that will be updated every frame
	self.components = {}
end

-- CALLED ON GAME START
-- load resources here
function Game:load()
end

-- CALLED ON GAME INIT
-- initialize variables here
function Game:init()
	self.components = {}
end

-- CALLED EVERY FRAME
function Game:update(dt)
	local components = self.components
	for i = 1, #components do
		components[i]:update(dt)
	end
end

-- CALLED EVERY FRAME
function Game:draw(dt)
	local components = self.components
	for i = 1, #components do
		components[i]:draw(dt)
	end
end

function Game:addComponent(component)
	assert(component.isInstanceOf and component:isInstanceOf(GameComponent), 
		"Cannot add non-component object to game component list")
	table.insert(self.components, component)
end