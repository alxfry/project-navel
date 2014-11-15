local anim8 = require "libs.anim8"

local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"

local Entity = Class "Entity"

function Entity:initialize(entityStatics, player)
    for key, value in pairs(entityStatics) do
        self[key] = value
    end
    dbgprint(player)
	self.health = self.health or 0
	self.position = GameMath.Vector2:new(0, 0)
    self.orientation = 0
    self.id = 0
    self.animation = false
    self:setPlayer(player)
end

function Entity:setPlayer(player)
    self.playerId = player.playerId
end

function Entity:setAnimation(imagePath, frameWidth, frameHeight, delay)
    local image = love.graphics.newImage(imagePath)
    local imageWidth, imageHeight = image:getDimensions()
    local grid = anim8.newGrid(frameWidth, frameHeight, imageWidth, imageHeight)

    local frames = imageWidth / frameWidth

    self.image = image
    self.animation = anim8.newAnimation(grid('1-' .. frames,1), delay)
end

function Entity:update(dt)
    if self.animation then
        self.animation:update(dt)
    end
end

function Entity:draw(dt)
    local x, y = self.position.x, self.position.y
    if self.animation then
        self.animation:draw(self.image, x, y, self.orientation, 1, 1, 32, 32)
    else
        love.graphics.circle("fill", x, y, 10, 10)
    end
end

function Entity:delete()
end

function Entity:setPosition(x, y)
	self.position.x = x
	self.position.y = y
end

return Entity
