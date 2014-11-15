local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"
local Entity = require "shared.entity"
local Unit = Entity:subclass("Unit")

-- speed: pixels/second
-- direction: radians
function Unit:initialize(speed, orientation)
    Entity.initialize(self)

    self.speed = speed
    self.orientation = orientation
    self.targetPosition = GameMath.Vector2:new(self.position.x, self.position.y)
end

function Unit:update(dt)
    local direction = (self.targetPosition - self.position)
    local length = direction:length()

    local factor = dt * self.speed / length
    if length > 1 and factor < 1 then
        self.position = self.position + direction * dt * self.speed / length
    else
        self.position = self.targetPosition
    end
    Entity.update(self, dt)
end

function Unit:moveTo(x, y)
    self.targetPosition = GameMath.Vector2:new(x, y)
end

return Unit