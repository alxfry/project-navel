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

    -- border scrolling
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

    -- dragging
    if self.dragAnchor then
        -- dbgprint
        self.translate.x = x - self.dragAnchor.x
        self.translate.y = y - self.dragAnchor.y
    end

    local w, h = self.logicCore.map:size()
    self.translate.x = GameMath.clamp(self.translate.x, -w + width, 0)
    self.translate.y = GameMath.clamp(self.translate.y, -h + height, 0)
end


-- click-through prevention. sucky, sucky Quickie! ;)
function InputHandler:isToolBar(x, y)
    local width, height = love.graphics.getDimensions()
    return y > height - 50
end

function InputHandler:mousePressed(x, y, button)
    if self:isToolBar(x, y) then
        return
    end

    local position = GameMath.Vector2:new(x, y) - self.translate
    self.dragAnchor = position
end

function InputHandler:mouseReleased(x, y, button)
    if self:isToolBar(x, y) then
        return
    end

    local function isSelectable(entity)
        return entity.player == self.logicCore.players[1] and entity.selectable
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
            local entity, distance = entityManager:findClosestEntity(position, isSelectable)
            self:selectEntity(entity and distance < 40 and entity.id)
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