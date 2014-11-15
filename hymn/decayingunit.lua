local Class = require "shared.middleclass"
local Unit = require "shared.unit"
local LogicCore = require "hymn.logiccore"

local DecayingUnit = Class("DecayingUnit", Unit)

function DecayingUnit:initialize(entityStatic, player)
	Unit.initialize(self, entityStatic, player)

	self.decayInterval = 1 -- in seconds
	self.decayAmount = 1 -- in health
	self.timeSinceLastDecay = 0
end

local themes = {
    "frost",
    "lava",
}

function DecayingUnit:setPlayer(player)
    self.player = player
    self.theme = themes[player.playerId] or themes[1]
    self:setAnimation("images/minion/" .. self.theme .. "/walk.png", 0.175)
end

function DecayingUnit:update(dt)
	Unit.update(self, dt)
	local dtLastDecay = self.timeSinceLastDecay
	dtLastDecay = dtLastDecay + dt

	if dtLastDecay > self.decayInterval then
		self.health = self.health - self.decayAmount
		self.timeSinceLastDecay = dtLastDecay - self.decayInterval
	else
		self.timeSinceLastDecay = dtLastDecay
	end

    -- DEATH
    if self.health <= 0 then
        LogicCore.entityManager:remove(self.id)
    end
end

return DecayingUnit