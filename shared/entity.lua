local anim8 = require "libs.anim8"

-- local blocking = require "shared.blocking"
local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"

local Entity = Class "Entity"

function Entity:initialize(entityStatics, player)
    for key, value in pairs(entityStatics) do
        self[key] = value
    end

	self.health = self.health or 0
    self.maxHealth = self.health
	self.position = GameMath.Vector2:new(0, 0)
    self.orientation = 0
    self.id = 0
    self.animation = false
    self.radius = 10
    self:setPlayer(player)

    -- blocking.addDynamicBlock(self.position.x, self.position.y)
end

function Entity:setPlayer(player)
    self.playerId = player.playerId
end

function Entity:setAnimation(imagePath, delay, scale)
    local image = love.graphics.newImage(imagePath)
    local imageWidth, imageHeight = image:getDimensions()
    local frameWidth, frameHeight = imageHeight, imageHeight
    local grid = anim8.newGrid(frameWidth, frameHeight, imageWidth, imageHeight)
    local frames = imageWidth / frameWidth

    self.scale = scale or 1
    self.spriteSize = imageHeight
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
        self.animation:draw(self.image, x, y, self.orientation, self.scale, self.scale, self.spriteSize/2, self.spriteSize/2)
    else
        love.graphics.circle("fill", x, y, self.radius, self.radius)
    end
end

function Entity:delete()
    -- blocking.removeDynamicBlock(self.position.x, self.position.y)
end

function Entity:setPosition(x, y)
    -- local oldX = self.position.x
    -- local oldY = self.position.y

	self.position.x = x
	self.position.y = y

    -- blocking.updateDynamicBlock(oldX, oldY, x, y)
end

function Entity:addHealth(amount)
    self.health = amount
end

function Entity:takeDamage(dmg)
    self.health = self.health - dmg
end

return Entity
