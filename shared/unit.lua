local GameMath = require "shared.gamemath"
local Entity = require "shared.entity"
local LogicCore = require "hymn.logiccore"
local Unit = Entity:subclass("Unit")

-- speed: pixels/second
-- orientation: radians
function Unit:initialize(entityStatic, player)
    Entity.initialize(self, entityStatic, player)

    self.speed = self.speed or 300
    -- self.orientation = orientation
    self.targetPosition = GameMath.Vector2:new(self.position.x, self.position.y)
end

function Unit:update(dt)
    local direction = (self.targetPosition - self.position)
    local length = direction:length()
    if length > 0 then
        self.orientation = math.atan2(direction.y, direction.x)
    end

    local factor = dt * self.speed / length
    if length > 1 and factor < 1 then
        self.position = self.position + direction * dt * self.speed / length
    else
        self.position.x = self.targetPosition.x
        self.position.y = self.targetPosition.y
    end
    Entity.update(self, dt)

    -- DEATH
    if self.health <= 0 then
        LogicCore.entityManager:remove(self.id)
    end
end

function Unit:moveTo(x, y)
    self.targetPosition.x = x
    self.targetPosition.y = y
end

function Unit:setPosition(x, y)
    self.targetPosition.x = x
    self.targetPosition.y = y
    Entity.setPosition(self, x, y)
end

return Unit
