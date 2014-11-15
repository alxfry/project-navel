local Unit = require "shared.unit"

local Enemy = Unit:subclass("Enemy")

local enemySpeed = 20
local enemyHealth = 100

-- speed: pixels/second
function Enemy:initialize(target, deadFunc)
    Unit.initialize(self, enemySpeed)
    self.type = "enemy"
    self.target = target
    self.maxHealth = enemyHealth
    self.health = enemyHealth
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
