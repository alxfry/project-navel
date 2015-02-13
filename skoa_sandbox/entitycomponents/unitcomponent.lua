local EntityComponent = require "smee.game_core.entitycomponent"

local UnitComponent = EntityComponent:subclass("UnitComponent")

function UnitComponent:init(unitStatics, playerId)
	self.initialHealth = unitStatics.unitComponent.health
	self.initialDamage = unitStatics.unitComponent.damage
	self.initialDefense = unitStatics.unitComponent.defense
	self.initialWalkSpeed = unitStatics.unitComponent.walkSpeed
end

return UnitComponent
