local anim8 = require "smee.libs.anim8"

-- local blocking = require "shared.blocking"
local Class = require "smee.libs.middleclass"
local GameMath = require "smee.logic.gamemath"
local Blocking = require "smee.logic.blocking"

local Entity = Class "Entity"

function Entity:initialize(entityStatics, playerId)
    for key, value in pairs(entityStatics) do
        self[key] = value
    end

    self.alpha = self.alpha or 255
    self.scale = self.scale or 1
    self.health = self.health or 0
    self.maxHealth = self.health
    self.orientation = 0
    self.id = 0
    self.animations = {}
    self.images = {}
    self.animation = false
    self.radius = self.radius or 10
    self:setPlayer(playerId)
	self:initPosition(0,0)
end

function Entity:setPlayer(playerId)
    self.playerId = playerId
end

function Entity:addAnimation(animationKey, imagePath, delay, onLoop)
    local image = love.graphics.newImage(imagePath)
    local imageWidth, imageHeight = image:getDimensions()
    local frameWidth, frameHeight = imageHeight, imageHeight
    local grid = anim8.newGrid(frameWidth, frameHeight, imageWidth, imageHeight)
    local frames = imageWidth / frameWidth

    self.spriteSize = imageHeight
    self.images[animationKey] = image
    self.animations[animationKey] = anim8.newAnimation(grid('1-' .. frames,1), delay, onLoop)
end

function Entity:setAnimation(imagePath, delay, onLoop)
    if delay == nil and onLoop == nil then
        self.animation = self.animations[imagePath]
        self.image = self.images[imagePath]
    else
        local image = love.graphics.newImage(imagePath)
        local imageWidth, imageHeight = image:getDimensions()
        local frameWidth, frameHeight = imageHeight, imageHeight
        local grid = anim8.newGrid(frameWidth, frameHeight, imageWidth, imageHeight)
        local frames = imageWidth / frameWidth

        self.spriteSize = imageHeight
        self.image = image
        self.animation = anim8.newAnimation(grid('1-' .. frames,1), delay, onLoop)
    end
end

function Entity:setRandomStartAnimationTime()
    self.animation.timer = math.random() * self.animation.durations[1]
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
    -- if self.blocking then
    --     Blocking.removeDynamicBlock(self.position.x, self.position.y)
    -- end
end

function Entity:initPosition(x, y)
    self.position = GameMath.Vector2:new(x, y)
    if self.blocking then
        local size = self.radius * 2
        Blocking.addDynamicBlock(x - self.radius, y - self.radius, size, size)
    end
end

function Entity:setPosition(x, y)
    local oldX = self.position.x
    local oldY = self.position.y

    self.position.x = x
    self.position.y = y

    if self.blocking then
        local size = self.radius * 2
        Blocking.addDynamicBlock(x - self.radius, y - self.radius, size, size)
        Blocking.removeDynamicBlock(oldX - self.radius, oldY - self.radius, size, size)
    end
end

-- find a position outside the entity closest to point
function Entity:closestPosition(point)
    local direction = point - self.position
    local length = self.radius + 5 
    direction:normalize()
    return length * direction + self.position
end

function Entity:addHealth(amount)
    self.health = self.health + amount
end

function Entity:takeDamage(dmg)
    self.health = self.health - dmg
end

return Entity
