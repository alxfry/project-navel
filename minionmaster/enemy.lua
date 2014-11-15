local Unit = require "shared.unit"
local Enemy = Unit:subclass("Enemy")

-- speed: pixels/second
function Enemy:initialize(speed, target, health, deadFunc)
    Unit.initialize(self, speed)
    self.target = target
    self.maxHealth = health
    self.health = health
    self.radius = 25
    self.deadFunc = deadFunc
end

function Enemy:update(dt)
    if self.health <= 0 then
        self.deadFunc(self)
    end

    self:moveTo(self.target.position.x, self.target.position.y)
    Unit.update(self, dt)
end

function Enemy:draw(dt)
    love.graphics.setColor(self.health/self.maxHealth * 255, 0, 0, 255)
    love.graphics.circle("fill", self.position.x, self.position.y, self.radius, self.radius)
end

return Enemy