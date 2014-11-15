local Unit = require "shared.unit"
local Entity = require "shared.entity"

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
function Minion:initialize(master, kind)
    Unit.initialize(self, minionSpeed)
    self.master = master
    self.kind = kind

    self:setAnimation("images/minion/" .. self.kind .. "/walk.png", 64, 64, 0.175)
end

function Minion:update(dt)
    if not self.target or self.target.health <= 0 then
        self.target = findNearestEnemy(self.position) or self.master
    end

    self:moveTo(self.target.position.x, self.target.position.y, self.target.radius)
    Unit.update(self, dt)

    local direction = (self.targetPosition - self.position)
    local length = direction:length()
    if length < self.target.radius then
        self.target.health = self.target.health - 1
    else

    end
end

function Minion:draw(dt)
    love.graphics.setColor(255, 255, 255, 255)
    Entity.draw(self, dt)
end

return Minion
