local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"
local InputHandler = Class "InputHandler"
local EntityStatics = require "hymn.staticdata.entitystatics"

function InputHandler:initialize(logicCore)
    self.logicCore = logicCore
    self.translate = GameMath.Vector2:new(0, 0)
end

local borderWidth = 20
local scrollSpeed = 500

function InputHandler:update(dt)
    local width, height = love.graphics.getDimensions()
    local x, y = love.mouse.getPosition()

    if x < borderWidth then
        self.translate.x = self.translate.x + scrollSpeed * dt
    elseif x > width - borderWidth then
        self.translate.x = self.translate.x - scrollSpeed * dt
    end

    if y < borderWidth then
        self.translate.y = self.translate.y + scrollSpeed * dt
    elseif y > height - borderWidth then
        self.translate.y = self.translate.y - scrollSpeed * dt
    end

    local w, h = self.logicCore.map:size()
    self.translate.x = GameMath.clamp(self.translate.x, -w + width, 0)
    self.translate.y = GameMath.clamp(self.translate.y, -h + height, 0)
end

function InputHandler:mousePressed(x, y, button)
    -- print("mousePressed", x, y, button)
end

function InputHandler:mouseReleased(x, y, button)
    local width, height = love.graphics.getDimensions()
    -- click-through prevention. sucky, sucky Quickie! ;)
    if y > height - 50 then
        return
    end

    local position = GameMath.Vector2:new(x, y) - self.translate
    local entityManager = self.logicCore.entityManager
    local logicCore = self.logicCore
    if button == "l" then
        if self.mode == "build" then
            local building = self.logicCore.entityManager:spawnFromEntityStatic(EntityStatics.spawnPortal, logicCore.players[1])
            building:setPosition(position.x, position.y)
            self:selectEntity(building.id)
            self.mode = false
        elseif self.mode == "path" then
            local entity = entityManager:entity(self.selection)
            entity:addPathPoint(position)
        else
            -- selection
            local entities = entityManager.entities
            local closestDist = 10000000
            local closestEntity
            for id, entity in pairs(entities) do
                local dist = GameMath.Vector2.distance(entity.position, position)
                if entity.selectable and dist < closestDist then
                    closestEntity = entity
                    closestDist = dist
                end
            end
            self:selectEntity(closestDist < 40 and closestEntity.id)
        end
    elseif button == "r" then
        self:selectEntity(false)
        self.mode = false
    end
end

function InputHandler:setMode(mode)
    local entityManager = self.logicCore.entityManager
    if mode == "build" then
        self.mode = "build"
    elseif mode == "path" then
        local entity = entityManager:entity(self.selection)
        entity:clearPath()
        self.mode = "path"
    end
end

function InputHandler:keyPressed(key, unicode)
end

function InputHandler:selectEntity(entityId)
    self.selection = entityId
end

return InputHandler