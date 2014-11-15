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

    -- self:setAnimation("images/minion/frost/attack.png", 0.175)
    -- self.attackAnim = self.animation:clone()
    self:setAnimation("images/minion/frost/walk.png", 0.175)
    -- self.walkAnim = self.animation:clone()
    self.attack = false
end

function Minion:update(dt)
    local wasAttacking = self.attack

    self.behavior:tick(dt)

    -- if not self.target or self.target == self.master or self.target.health <= 0 then
    --     self.target = self:findNearestEnemy(self.position, self.attackRange) or self.master
    -- end

    -- self:moveTo(self.target.position.x, self.target.position.y, self.target.spriteSize)
    Unit.update(self, dt)

    -- print(self.attack, wasAttacking)

    if self.attack then
        if not wasAttacking then
            self:setAnimation("images/minion/frost/attack.png", 0.175)
            print("attackAnim")
        end
        if self.target then
            self.target:takeDamage(self.damage)
        end
    elseif wasAttacking then
        self:setAnimation("images/minion/frost/walk.png", 0.175)
        print("walkAnim")
    end
end

function Minion:draw(dt)
    love.graphics.setColor(255, 255, 255, 255)
    Entity.draw(self, dt)
end

function Minion:takeDamage(dmg)
    print("miniondmg")
    -- self.health = self.health - dmg
end

return Minion
