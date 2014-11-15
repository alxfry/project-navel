require "libs.AnAL"

local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"

local Entity = Class "Entity"

function Entity:initialize()
	self.health = 0
	self.position = GameMath.Vector2:new(0, 0)
    self.orientation = 0
    self.id = 0
    self.animation = false
end

function Entity:setAnimation(image, frameWidth, frameHeight, delay)
    local img = love.graphics.newImage(image)
    self.animation = newAnimation(img, frameWidth, frameHeight, delay or 0.1, 0)
end

function Entity:update(dt)
    if self.animation then
        self.animation:update(dt)
    end
end

function Entity:draw(dt)
    if self.animation then
        self.animation:draw(self.position.x, self.position.y, self.orientation, 1, 1, 32, 32)
    else
        love.graphics.circle("fill", self.position.x, self.position.y, 10, 10)
    end
end

function Entity:delete()
end

function Entity:setPosition(x, y)
	self.position.x = x
	self.position.y = y
end

return Entity
