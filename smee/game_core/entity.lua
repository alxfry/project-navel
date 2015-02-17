local anim8 = require "smee.libs.anim8"

-- local blocking = require "shared.blocking"
local Class = require "smee.libs.middleclass"
local GameMath = require "smee.logic.gamemath"
local Blocking = require "smee.logic.blocking"

local Entity = Class "Entity"

local ROOT_TWO = math.sqrt(2)

function Entity:initialize(playerId)
-- TODO: Get rid of unnecessary stuff
    self.alpha = self.alpha or 255
    self.scale = self.scale or 1
    self.orientation = 0
    self.id = 0
    self.animations = {}
    self.images = {}
    self.animation = false
    self.radius = self.radius or 10
    self:setPlayer(playerId)
	self:initPosition(0,0)
    self.width, self.height = 64, 64
    -- Standard bounding box, can be overwritten by components
    self.boundingBox = GameMath.AABB:new(0,0,self.width,self.height)
    self.staticProperties = {}
    self.components = {}
    self.componentsMap = {}
end

function Entity.static.createFromEStat(entityStatic, playerId, ...)
    local componentClasses = SMEE.GetGame():getResources("componentClasses")
    local entity = Entity:new(playerId, ...)

    for propertyName, value in pairs(entityStatic) do
        if componentClasses[propertyName] then
            local component = entity:addComponent(componentClasses[propertyName])
            component:init(self, value)            
        else
            entity.staticProperties[propertyName] = value
        end
    end

    return entity
end

function Entity:setPlayer(playerId)
    self.playerId = playerId
end

function Entity:addAnimation(animationKey, image, delay, onLoop)
    if type(image) == "string" then
        image = love.graphics.newImage(image)
    end
    local imageWidth, imageHeight = image:getDimensions()
    local frameWidth, frameHeight = 64, 64
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
    for i = 1, #self.components do
        self.components[i]:update(dt)
    end
    -- if self.animation then
    --     self.animation:update(dt)
    -- end
end

function Entity:draw(dt)
    local x, y = self.position.x, self.position.y
    for i = 1, #self.components do
        self.components[i]:draw(dt)
    end
    -- love.graphics.circle("fill", x, y, self.radius, self.radius)
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

function Entity:getPosition()
    return self.position
end

-- find a position outside the entity closest to point
function Entity:closestPosition(point)
    local direction = point - self.position
    local length = (self.radius+1) * ROOT_TWO
    direction:normalize()
    return length * direction + self.position
end

function Entity:addComponent(componentClass, ...)
    local newComponent = componentClass:new(self, ...)
    self.components[#self.components + 1] = newComponent
    self.componentsMap[componentClass.name] = newComponent
    return newComponent
end

function Entity:getComponent(key)
    return self.components[key] or self.componentsMap[key]
end

function Entity:wasClicked(clickPos)
    -- dbgprint("wasClicked")
    -- local clickPos = GameMath.Vector2:new(x,y)
    local hasCollision = self.boundingBox:checkCollision(GameMath.AABB.Zero, self.position, clickPos)
    return hasCollision
end

return Entity
