local Unit = require "shared.unit"

local Enemy = Unit:subclass("Enemy")

local content = require "minionmaster.content"
local state = require "minionmaster.state"

-- speed: pixels/second
function Enemy:initialize(entityStatics, target)
    Unit.initialize(self, entityStatics, state.player)
    self.type = "enemy"
    self.target = target
    self.maxHealth = self.health
end

function Enemy:update(dt)
    if self.health <= 0 then
        state.entityManager:remove(self.id)
        return
    end

    self:moveTo(self.target.position.x, self.target.position.y)
    Unit.update(self, dt)
end

function Enemy:draw(dt)
    local x, y = self.position.x, self.position.y
    love.graphics.setColor(self.health/self.maxHealth * 255, 0, 0, 255)
    love.graphics.circle("fill", x, y, self.radius, self.radius)
end

return Enemy
