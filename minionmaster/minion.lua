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
    self.behavior = BehaviorTree.BehaviorTree:new(self, BehaviorTrees:createMinionTree())

    -- self:setAnimation("images/minion/frost/attack.png", 0.175)
    -- self.attackAnim = self.animation:clone()
    self:setAnimation("images/minion/frost/walk.png", 0.175)
    -- self.walkAnim = self.animation:clone()
    self.attack = false
end

function Minion:update(dt)

    if self.health <= 0 then
        state.entityManager:remove(self.id)
        return
    end

    Unit.update(self, dt)

    if self.attack then
        if not self.wasAttacking then
            self:setAnimation("images/minion/frost/attack.png", 0.175)
            -- print("attackAnim")
        end
    elseif self.wasAttacking then
        self:setAnimation("images/minion/frost/walk.png", 0.175)
        -- print("walkAnim")
    end

    self.wasAttacking = self.attack
    self.behavior:tick(dt)
end

function Minion:draw(dt)
    love.graphics.setColor(255, 255, 255, 255)
    Entity.draw(self, dt)
end

function Minion:takeDamage(dmg)
    -- print("miniondmg")
    self.health = self.health - dmg
end

return Minion
