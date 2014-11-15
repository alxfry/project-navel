require("AnAL")

local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"

local Entity = Class "Entity"

function Entity:initialize()
	self.position = GameMath.Vector2:new(0, 0)
end

function Entity:setAnimation(image, frameWidth, frameHeight, delay)
    local img = love.graphics.newImage(image)
    self.animation = newAnimation(img, frameWidth, frameHeight, delay or 0.1, 0)
    self.animation:setMode("bounce")
end

function Entity:update(dt)
    self.animation:update(dt)
end

function Entity:draw(dt)
    self.animation:draw(self.position.x - 128, self.position.y - 128)
end

function Entity:delete()
end

function Entity:setPosition(x, y)
	self.position.x = x
	self.position.y = y
end

return Entity