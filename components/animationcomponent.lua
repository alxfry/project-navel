local EntityComponent = require "smee.game_core.entitycomponent"

local NavelGame = require "navelgame"

local AnimationComponent = EntityComponent:subclass("AnimationComponent")

-- CONSTRUCTOR
function AnimationComponent:initialize(entity)
	EntityComponent.initialize(self, entity)
end

function AnimationComponent:init(staticData)
	EntityComponent.init(self)
	self.animations = {}
	self.animationImageMap = {}

	for i = 1, #staticData do
		local anim = staticData[i]
		local imagePath = anim.imagePath
		if not NavelGame.
	end
end

function AnimationComponent:update(dt)
	EntityComponent:update(dt)
end	

function AnimationComponent:draw(dt)
	EntityComponent:draw(dt)
end

return AnimationComponent