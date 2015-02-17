local EntityComponent = require "smee.game_core.entitycomponent"
local Table = require "skoa_sandbox.utl.table"

local UnitComponent = EntityComponent:subclass("UnitComponent")

function UnitComponent:init(owner, unitStatics)
    EntityComponent.init(self, owner)
	
    self.name = unitStatics.name
    
    self.health = unitStatics.health
    self.damage = unitStatics.damage
    self.defense = unitStatics.defense
    self.walkSpeed = unitStatics.walkSpeed

	self.initialHealth = unitStatics.health
	self.initialDamage = unitStatics.damage
	self.initialDefense = unitStatics.defense
	self.initialWalkSpeed = unitStatics.walkSpeed
end

return UnitComponent
