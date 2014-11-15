local Unit = require "shared.unit"
local Entity = require "shared.entity"

local state = require "minionmaster.state"
local content = require "minionmaster.content"
local state = require "minionmaster.state"

local MinionBehaviorTree = require "minionmaster.behaviors.minionbehaviortree"
local BehaviorTree = require "shared.behaviortree"

local Minion = Unit:subclass("Minion")

function Minion:findNearestEnemy(position, range)
    local nearest
    local minDist = range * range
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

-- speed: pixels/second
function Minion:initialize(entityStatics, master)
    Unit.initialize(self, entityStatics, state.player)
    self.master = master
    self.behavior = BehaviorTree.BehaviorTree:new(self, MinionBehaviorTree)
    self.behavior:start()

    -- self:setAnimation("images/minion/frost/attack.png", 0.175)
    -- self.attackAnim = self.animation:clone()
    self:setAnimation("images/minion/frost/walk.png", 0.175)
    -- self.walkAnim = self.animation:clone()
    self.attack = false
end

function Minion:update(dt)
    self.behavior:update(dt, self)

    -- if not self.target or self.target == self.master or self.target.health <= 0 then
    --     self.target = self:findNearestEnemy(self.position, self.attackRange) or self.master
    -- end

    -- self:moveTo(self.target.position.x, self.target.position.y, self.target.spriteSize)
    -- Unit.update(self, dt)

    -- local direction = (self.targetPosition - self.position)
    -- local length = direction:length()
    -- if length < self.target.spriteSize then
    --     if not self.attack then
    --         self:setAnimation("images/minion/frost/attack.png", 0.175)
    --         self.attack = true
    --     end
    --     self.target.health = self.target.health - 1
    -- elseif self.attack then
    --     self.attack = false
    --     self:setAnimation("images/minion/frost/walk.png", 0.175)
    -- end
end

function Minion:draw(dt)
    love.graphics.setColor(255, 255, 255, 255)
    Entity.draw(self, dt)
end

return Minion
