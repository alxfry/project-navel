local GameMath = require "shared.gamemath"
local Entity = require "shared.entity"
local Unit = Entity:subclass("Unit")

-- speed: pixels/second
-- direction: radians
function Unit:initialize(speed, orientation, startingHealth)
    Entity.initialize(self)

    self.health = startingHealth
    self.speed = speed
    self.orientation = orientation
    self.targetPosition = GameMath.Vector2:new(self.position.x, self.position.y)
end

local themes = {
    "frost",
    "lava",
}

function Unit:setPlayer(player)
    Entity:setPlayer(player)
    self.theme = themes[player.playerId] or themes[1]
    self:setAnimation("images/minion/" .. self.theme .. "/walk.png", 64, 64, 0.175)
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
