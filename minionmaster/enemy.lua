local Unit = require "shared.unit"

local Enemy = Unit:subclass("Enemy")

local content = require "minionmaster.content"
local state = require "minionmaster.state"

local BehaviorTrees = require "minionmaster.behaviors.behaviortrees"
local BehaviorTree = require "shared.behaviortree"

-- speed: pixels/second
function Enemy:initialize(entityStatics)
    Unit.initialize(self, entityStatics, state.player)
    self.type = "enemy"
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

    local wasAttacking = self.attack

    Unit.update(self, dt)
    self.behavior:tick(dt)

    if self.attack then
        if not wasAttacking then
            self:setAnimation("images/minion/lava/attack.png", 0.175)
        end
    elseif wasAttacking then
        self:setAnimation("images/minion/lava/walk.png", 0.175)
    end
end

function Enemy:draw(dt)
    -- love.graphics.circle("line", self.position.x, self.position.y, self.attackRange, 100);
    Unit.draw(self, dt)
end

return Enemy
