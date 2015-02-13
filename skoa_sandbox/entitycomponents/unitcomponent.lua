local EntityComponent = require "smee.game_core.entitycomponent"

local UnitComponent = EntityComponent:subclass("UnitComponent")

function UnitComponent:init(owner, unitStatics)
    EntityComponent.init(self, owner)
	self.initialHealth = unitStatics.health
	self.initialDamage = unitStatics.damage
	self.initialDefense = unitStatics.defense
	self.initialWalkSpeed = unitStatics.walkSpeed
end

return UnitComponent
