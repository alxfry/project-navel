local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"
local Entity = require "shared.entity"
local Unit = Entity:subclass("Unit")

-- speed: pixels/second
-- direction: radians
function Unit:initialize(speed, direction)
    Entity.initialize(self)

    self.speed = speed
    self.direction = direction
    self.targetPosition = GameMath.Vector2:new(self.position.x, self.position.y)
end

function Unit:update(dt)
    local direction = (self.targetPosition - self.position)
    local length = GameMath.Vector2.length(direction)
    if length > 1 then
        direction = direction/length
        self.position = self.position + direction * dt * self.speed
    end
end

function Unit:moveTo(x, y)
    self.targetPosition = GameMath.Vector2:new(x, y)
end

return Unit