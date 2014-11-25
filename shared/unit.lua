local flux     = require "smee.libs.flux"
local blocking = require "smee.logic.blocking"
local GameMath = require "smee.logic.gamemath"
local Entity   = require "smee.game_core.entity"


local Unit = Entity:subclass("Unit")

-- speed: pixels/second
-- orientation: radians
function Unit:initialize(entityStatic, player)
    Entity.initialize(self, entityStatic, player)

    self.speed = self.speed or 300
    -- self.orientation = orientation
    self.targetPosition = GameMath.Vector2:new(self.position.x, self.position.y)
    self.targetEntity = nil
    self.targetDirection = Vector2:new(0,0)
    self.stopRange = 30
    self.waypoints = false
    self.dead = false
end

function Unit:moveTo(targetPos, stopRange)
    -- RESET OLD TARGET / SET NEW
    self.targetEntity = nil
    self.targetPosition = targetPos
    self.stopRange = stopRange or self.stopRange

    -- CAN RETURN NIL! Careful, in one behavior we expected to get always something
    self.waypoints = blocking.findPath(self.position.x, self.position.y,
                                       targetPos.x, targetPos.y)
    return self.waypoints
end

function Unit:moveToTarget(targetEntity)
    -- SET NEW TARGET
    local targetPos = targetEntity:getPosition()
    self.targetEntity = targetEntity
    self.targetPosition = targetPos
    self.targetDirection = targetPos - self.position 

    self.waypoints = blocking.findPath(self.position.x, self.position.y,
                                       targetPos.x, targetPos.y)
    return self.waypoints
end


function Unit:reachedTarget(target, step)
    local direction = (target - self.position)
    local length = direction:length()

    -- RETURN REACHED, direction vector, direction length
    return length <= step, direction, length
end

function Unit:checkDirection()
    if self.targetEntity then
        -- COMPARE ANGLE TO ANGLE AT PATHFIND: If the angle has changed too much we need to pathfind again
        local angle = math.acos(self.targetDir:dot(self.targetPosition))
        if angle > 15 then
            self:moveToTarget(self.targetEntity)
        end
    end
end

function Unit:updateMove(dt)
    self:checkDirection()
    if self.waypoints and #self.waypoints > 0 then
        local waypoints = self.waypoints

        -- TODO: not create new vector every turn
        local target = GameMath.Vector2:new(waypoints[1].x, waypoints[1].y)
        local step = dt * self.speed

        local reached, direction, length = self:reachedTarget(target, step)

        -- Update orientation
        if length > 0 then
            local newOrientation = math.atan2(direction.y, direction.x)
            -- self.orientation = newOrientation
            flux.to(self, 0.04, { orientation = newOrientation }):ease("quadinout")
        end

        if #waypoints > 1 or length > self.stopRange then
            if reached then
                self:setPosition(target.x, target.y)
                table.remove(waypoints, 1)
            else
                direction:normalize()
                local newPosition = self.position + direction * step
                self:setPosition(newPosition.x, newPosition.y)
            end
            return false
        else
            self.waypoints = nil
            return true
        end
    end
    
    return true
end

function Unit:drawPath()
    if self.waypoints and #self.waypoints > 0 then
        local waypoints = self.waypoints

        -- Draw the path to the destination
        love.graphics.setColor(255,0,0,64)
        love.graphics.setPointSize(5)
        local px, py = self.position.x, self.position.y
        for i, waypoint in ipairs(waypoints) do
            local x, y = waypoint.x, waypoint.y
            if px then
                love.graphics.line(px, py, x, y)
            else
                love.graphics.point(x, y)
            end
            px, py = x, y
        end
        love.graphics.point(px, py)
    end
end

function Unit:setPosition(x, y)
    self.targetPosition.x = x
    self.targetPosition.y = y
    Entity.setPosition(self, x, y)
end

function Unit:getTargetPosition()
    return self.targetPosition.x, self.targetPosition.y
end

return Unit
