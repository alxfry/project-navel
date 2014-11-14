local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"
print("sdfagafg")
local Entity = Class "Entity"

function Entity:initialize()
	self.position = GameMath.Vector2.new(0,0)
end

function Entity:update(dt)

end

function Entity:draw(dt)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.circle("fill", self.position.x, self.position.y, 30, 30)
end

function Entity:setPosition(x, y)
	self.position.x = x
	self.position.y = y
end

return Entity