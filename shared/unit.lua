local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"
local Entity = require "shared.entity"
local Unit = Entity:subclass("Unit")

-- speed: pixels/second
function Unit:initialize(speed)
    Entity.initialize(self)

    self.speed = speed
    self.targetPosition = GameMath.Vector2:new(self.position.x, self.position.y)
end

function Unit:update(dt)
    -- print(self.position.x, self.position.y)
    local direction = self.targetPosition - self.position
    -- direction:normalize()
    self.position = self.position + direction * dt * self.speed
end

function Unit:moveTo(x, y)
    self.targetPosition = GameMath.Vector2:new(x, y)
end

return Unit