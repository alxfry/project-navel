local EntityComponent = require "smee.game_core.entitycomponent"
local Table = require "sandbox.utl.table"

local UnitComponent = EntityComponent:subclass("UnitComponent")

function UnitComponent:init(owner, unitStatics)
    EntityComponent.init(self, owner)
	
    self.name = unitStatics.name
    
    self.health = unitStatics.health
    self.damage = unitStatics.damage
    self.attackRange = unitStatics.attackRange
    self.defense = unitStatics.defense
    self.walkSpeed = unitStatics.walkSpeed
    self.initiative = unitStatics.initiative

    self.initialHealth = unitStatics.health
    self.initialDamage = unitStatics.damage
    self.initialAttackRange = unitStatics.attackRange
    self.initialDefense = unitStatics.defense
    self.initialWalkSpeed = unitStatics.walkSpeed
end

return UnitComponent
