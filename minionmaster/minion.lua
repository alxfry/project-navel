local Unit = require "shared.unit"

local state = require "minionmaster.state"

local Minion = Unit:subclass("Minion")

local function findNearestEnemy(position)
    local nearest
    local minDist = math.huge
    for id, entity in pairs(state.entityManager.entities) do
        if entity.type == "enemy" then
            local dist = (entity.position - position):sqLength()
            if dist < minDist then
                minDist = dist
                nearest = entity
            end
        end
    end

    return nearest
end

local minionSpeed = 150

-- speed: pixels/second
function Minion:initialize(master)
    Unit.initialize(self, minionSpeed)
    self.master = master
end

function Minion:update(dt)
    if not self.target or self.target.health <= 0 then
        self.target = findNearestEnemy(self.position) or self.master
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
    local x, y = self.position.x, self.position.y
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.circle("fill", x, y, 10, 10)
end

return Minion
