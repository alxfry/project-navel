local blocking = require "shared.blocking"
local GameMath = require "shared.gamemath"
local Entity = require "shared.entity"
local Unit = Entity:subclass("Unit")

-- speed: pixels/second
-- orientation: radians
function Unit:initialize(entityStatic, player)
    Entity.initialize(self, entityStatic, player)

    self.speed = self.speed or 300
    -- self.orientation = orientation
    self.targetPosition = GameMath.Vector2:new(self.position.x, self.position.y)
    self.stopRange = 1
    self.waypoints = false
end

function Unit:update(dt)
    if self.waypoints and #self.waypoints > 0 then
        local waypoints = self.waypoints

        local target = GameMath.Vector2:new(waypoints[1].x, waypoints[1].y)
        local direction = (target - self.position)
        local length = direction:length()

        -- Update orientation
        if length > 0 then
            self.orientation = math.atan2(direction.y, direction.x)
        end

        local reached = length <= dt * self.speed

        -- print(length, reached, self.position, target)

        if #waypoints > 1 or length > self.stopRange then
            if reached then
                self.position.x = target.x
                self.position.y = target.y
                table.remove(waypoints, 1)
            else
                self.position = self.position + direction * dt * self.speed / length
            end
        end
    end

    Entity.update(self, dt)
end

function Unit:moveTo(x, y, stopRange)
    self.targetPosition.x = x
    self.targetPosition.y = y
    self.stopRange = stopRange or self.stopRange

    self.waypoints = blocking.findPath(self.position.x, self.position.y,
                                       self.targetPosition.x, self.targetPosition.y)
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

return Unit
