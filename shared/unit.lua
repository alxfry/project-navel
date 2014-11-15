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
end

function Unit:update(dt)
    local direction = (self.targetPosition - self.position)
    local length = direction:length()
    if length > 0 then
        self.orientation = math.atan2(direction.y, direction.x)
    end

    local factor = dt * self.speed / length
    if length > self.stopRange and factor < 1 then
        local newpos = self.position + direction * dt * self.speed / length
        if not blocking.collides(newpos.x, newpos.y) then
            self.position = newpos
        end
    elseif self.stopRange <= 1 then
        if not blocking.collides(self.targetPosition.x, self.targetPosition.y) then
            self.position.x = self.targetPosition.x
            self.position.y = self.targetPosition.y
        end
    end

    Entity.update(self, dt)
end

function Unit:moveTo(x, y, stopRange)
    self.targetPosition.x = x
    self.targetPosition.y = y
    self.stopRange = stopRange or self.stopRange
end

function Unit:setPosition(x, y)
    self.targetPosition.x = x
    self.targetPosition.y = y
    Entity.setPosition(self, x, y)
end

return Unit
