local Unit = require "shared.unit"
local Minion = Unit:subclass("Minion")

-- speed: pixels/second
function Minion:initialize(speed, target)
    Unit.initialize(self, speed)
    self.target = target
end

function Minion:update(dt)
    if self.target.health <= 0 then
        self.target = findEnemy()
    end

    self:moveTo(self.target.position.x, self.target.position.y)
    Unit.update(self, dt)

    local direction = (self.targetPosition - self.position)
    local length = direction:length()
    if length < self.target.radius then
        self.target.health = self.target.health - 1
    end
end

function Minion:draw(dt)
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.circle("fill", self.position.x, self.position.y, 10, 10)
end

return Minion