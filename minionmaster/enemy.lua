local Unit = require "shared.unit"

local Enemy = Unit:subclass("Enemy")

local content = require "minionmaster.content"
local state = require "minionmaster.state"

local BehaviorTrees = require "minionmaster.behaviors.behaviortrees"
local BehaviorTree = require "shared.behaviortree"

-- speed: pixels/second
function Enemy:initialize(entityStatics, target)
    Unit.initialize(self, entityStatics, state.player)
    self.type = "enemy"
    self.target = target
    self.maxHealth = self.health

    self.behavior = BehaviorTree.BehaviorTree:new(self, BehaviorTrees:createEnemyTree())

    self:setAnimation("images/minion/lava/walk.png", 0.175)
    self.attack = false
end

function Enemy:update(dt)
    if self.health <= 0 then
        state.dna = state.dna + self.dna
        state.entityManager:remove(self.id)
        return
    end

    Unit.update(self, dt)

    if self.attack then
        if not self.wasAttacking then
            self:setAnimation("images/minion/lava/attack.png", 0.175)
            -- print("attackAnim")
        end
    elseif self.wasAttacking then
        self:setAnimation("images/minion/lava/walk.png", 0.175)
        -- print("walkAnim")
    end

    self.wasAttacking = self.attack
    self.behavior:tick(dt)
end

return Enemy
