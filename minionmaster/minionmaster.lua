local Unit = require "shared.unit"

local MinionMaster = Unit:subclass("MinionMaster")

local masterSpeed = 100

-- speed: pixels/second
function MinionMaster:initialize()
    Unit.initialize(self, masterSpeed, 0 , 1000)
    self.radius = 20
end

function MinionMaster:update(dt)
    local moveX = (love.keyboard.isDown("d") and 2 or 0) - (love.keyboard.isDown("a") and 2 or 0)
    local moveY = (love.keyboard.isDown("s") and 2 or 0) - (love.keyboard.isDown("w") and 2 or 0)

    self:moveTo(self.position.x + moveX, self.position.y + moveY)
    Unit.update(self, dt)
end

function MinionMaster:draw(dt)
    local x, y = self.position.x, self.position.y
    love.graphics.setColor(0, 0, 255, 255)
    love.graphics.circle("fill", x, y, self.radius, self.radius)
end

return MinionMaster
