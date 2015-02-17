-- NavelGame Class
local flux  = require "smee.libs.flux"
local anim8 = require "smee.libs.anim8"

local Game = require "smee.game_core.game"

local Entity = require "smee.game_core.entity"

local GameComponent     = require "smee.game_core.gamecomponent"
local EntityManager     = require "smee.game_core.entitymanager"
local ComponentImporter = require "smee.io.componentimporter"
local MapComponent      = require "skoa_sandbox.mapcomponent"
local UiComponent       = require "skoa_sandbox.uicomponent"
local Table             = require "skoa_sandbox.utl.table"
local InputHandler      = require "skoa_sandbox.inputhandler"
local loveframes        = require("libs.loveframes")

local NavelGame = Game:subclass("NavelGame")

-- CALLED ON GAME START
-- load resources here
function NavelGame:load()
	Game.load(self)
	self.resources = {
        spritesheets = {},
        images = {},
        componentClasses = {},
        entityStatics = {}
	}
    ComponentImporter.loadComponentClasses(self.resources.componentClasses, "skoa_sandbox\\entitycomponents")
    self.resources.entityStatics = require "skoa_sandbox.statics.entitydefinitions"
    self.resources.images["BGImage"] = love.graphics.newImage("/skoa_sandbox/resources/grass_wallpaper.jpg")
end

-- CALLED ON GAME INIT
-- initialize variables here
function NavelGame:init()
	Game.init(self)

    self.mapComponent = MapComponent:new(self.resources.images["BGImage"])
    self:addComponent(self.mapComponent)

    self.uiComponent = UiComponent:new()
    self:addComponent(self.uiComponent)

	self.entityManager = EntityManager:new(self)
	self:addComponent(self.entityManager)

    self.inputHandler = InputHandler:new()
    self:addComponent(self.inputHandler)

	-- Create first encounter entity. Entity holds a battlefield component which has its units in 'units'.
	self.currentEncounter = Entity.static.createFromEStat(self.resources.entityStatics.FirstEncounter, 1)
	self.entityManager:add(self.currentEncounter)
end

-- CALLED EVERY FRAME
function NavelGame:update(dt)
	Game.update(self, dt)
    -- mainChar:update(dt)
	-- NavelGame.mainAnimation:update(dt)
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
end

return NavelGame