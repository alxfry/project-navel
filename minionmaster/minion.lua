local Unit = require "shared.unit"
local Entity = require "shared.entity"

local state = require "minionmaster.state"
local content = require "minionmaster.content"
local state = require "minionmaster.state"

local BehaviorTrees = require "minionmaster.behaviors.behaviortrees"
local BehaviorTree = require "shared.behaviortree"

local Minion = Unit:subclass("Minion")

function Minion:findNearestEnemy(position, range)
    local nearest
    local minDist = range * range
    for id, entity in pairs(state.entityManager.entities) do
        if not entity.dead and entity.type == "enemy" then
            local dist = (entity.position - position):sqLength()
            if dist < minDist then
                minDist = dist
                nearest = entity
            end
        end
    end

    return nearest
end

-- speed: pixels/second
function Minion:initialize(entityStatics, master)
    Unit.initialize(self, entityStatics, state.player)
    self.master = master
    self.behavior = BehaviorTree.BehaviorTree:new(self, BehaviorTrees:createMinionTree())

    self:setAnimation("images/minion/frost/walk.png", 0.175)
    self:setRandomStartAnimationTime()
    self.attack = false
    self.fadeOutTime = 1
    self.maxFadeOutTime = 1
end

function Minion:update(dt)
    if self.dead then
        self.fadeOutTime = self.fadeOutTime - dt
        if self.fadeOutTime <= 0 then
            state.entityManager:remove(self.id)
        end
        Unit.update(self, dt)
        return
    end

    if self.health <= 0 then
        self.dead = true
        self:setAnimation("images/minion/frost/die.png", 0.175, 1, "pauseAtEnd")
        return
    end

    local wasAttacking = self.attack

    Unit.update(self, dt)
    self.behavior:tick(dt)

    if self.attack then
        if not wasAttacking then
            self:setAnimation("images/minion/frost/attack.png", 0.175)
            self:setRandomStartAnimationTime()
        end
    elseif wasAttacking then
        self:setAnimation("images/minion/frost/walk.png", 0.175)
        self:setRandomStartAnimationTime()
    end
end

function Minion:draw(dt)
    love.graphics.setColor(255, 255, 255, self.fadeOutTime/self.maxFadeOutTime * 255)
    -- love.graphics.circle("line", self.position.x, self.position.y, self.attackRange, 100);
    Unit.draw(self, dt)
end

return Minion
