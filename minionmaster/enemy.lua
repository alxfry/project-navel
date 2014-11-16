local flux          = require "libs.flux"

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

    self:addAnimation("walk", "images/minion/lava/walk.png", 0.175)
    self:addAnimation("attack", "images/minion/lava/attack.png", 0.175)
    self:addAnimation("die", "images/minion/lava/die.png", 0.175, "pauseAtEnd")
    self:setAnimation("walk")
    self.attack = false
    self:setRandomStartAnimationTime()
end

function Enemy:update(dt)
    Unit.update(self, dt)
    if self.dead then
        return
    end

    if self.health <= 0 then
        self.dead = true
        flux.to(self, 0.7, { scale = 1.5, alpha = 0 }):ease("quadin"):oncomplete(function()
            state.entityManager:remove(self.id)
        end)
        self:setAnimation("die")
        return
    end

    local wasAttacking = self.attack

    self.behavior:tick(dt)

    if self.attack then
        if not wasAttacking then
            self:setAnimation("attack")
            self:setRandomStartAnimationTime()
        end
    elseif wasAttacking then
        self:setAnimation("walk")
        self:setRandomStartAnimationTime()
    elseif not self.moving then
        -- self:setAnimation("walk")
        -- self.animation:pauseAtStart()
    end
end

function Enemy:draw(dt)
    love.graphics.setColor(255, 255, 255, self.alpha)
    -- love.graphics.circle("line", self.position.x, self.position.y, self.attackRange, 100);
    Unit.draw(self, dt)
end

return Enemy
