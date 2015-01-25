-- NavelGame Class
local flux  = require "smee.libs.flux"
local anim8 = require "smee.libs.anim8"

local Game = require "smee.game_core.game"

local Entity = require "smee.game_core.entity"

local GameComponent = require "smee.game_core.gamecomponent"
local EntityManager = require "smee.game_core.entitymanager"
-- local InputManager	= require "smee.game_core.inputmanager"

local NavelGame = Game:subclass("NavelGame")

NavelGame.static.resources = {
	spritesheets = {},
}

-- CALLED ON GAME START
-- load resources here
function NavelGame:load()
	Game.load(self)
	NavelGame.resources = {
		spritesheets = {},
	}
	sourcePath = "/resources/c_mustache.png"
	resources.spritesheets[sourcePath] = love.graphics.newImage(sourcePath)
end

-- CALLED ON GAME INIT
-- initialize variables here
function NavelGame:init()
	Game.init(self)

	self.entityManager = EntityManager:new(self)
	self:addComponent(self.entityManager)

	local mainChar = Entity:new({})
	mainChar:addAnimation("Explain_Right", resources.spritesheets.mainChar, 0.15)
	mainChar:setAnimation("Explain_Right")

	local bwaa = anim8.newGrid(64,64,resources.spritesheets.mainChar:getWidth(),resources.spritesheets.mainChar:getHeight())
	NavelGame.mainAnimation = anim8.newAnimation(bwaa('1-7',4), 0.2)
end

-- CALLED EVERY FRAME
function NavelGame:update(dt)
	Game.update(self, dt)
	NavelGame.mainAnimation:update(dt)
	local components = self.components
	for i = 1, #components do
		components[i]:update(dt)
	end
end

-- CALLED EVERY FRAME
function NavelGame:draw(dt)
	Game.draw(self, dt)
	local components = self.components
	for i = 1, #components do
		components[i]:draw(dt)
	end
	NavelGame.mainAnimation:draw(resources.spritesheets.mainChar,200,200)
end

return NavelGame