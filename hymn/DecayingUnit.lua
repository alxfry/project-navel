local Class = require "shared.middleclass"
local Unit = require "shared.unit"

local DecayingUnit = Class("DecayingUnit", Unit)

function DecayingUnit:initialize(speed, orientation, startingHealth)
	startingHealth = startingHealth or 12
	Unit.initialize(self, speed, orientation, startingHealth)

	self.decayInterval = 1 -- in seconds
	self.decayAmount = 1
	self.timeSinceLastDecay = 0
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
end