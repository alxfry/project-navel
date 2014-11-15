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

    self:setAnimation("images/minion/lava/attack.png", 0.175)
    self.attackAnim = self.animation
    self:setAnimation("images/minion/lava/walk.png", 0.175)
    self.walkAnim = self.animation
end

function Enemy:update(dt)
    if self.health <= 0 then
        state.entityManager:remove(self.id)
        state.dna = state.dna + self.dna
        return
    end

    self:moveTo(self.target.position.x, self.target.position.y)
    Unit.update(self, dt)
    self:updateMove(dt)
end

function Enemy:takeDamage(dmg)
    self.health = self.health - dmg
end

return Enemy
