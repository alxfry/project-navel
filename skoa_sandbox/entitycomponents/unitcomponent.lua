local EntityComponent = require "smee.game_core.entitycomponent"
local Table = require "skoa_sandbox.utl.table"

local UnitComponent = EntityComponent:subclass("UnitComponent")

function UnitComponent:init(owner, unitStatics)
    EntityComponent.init(self, owner)
	dbgprint("UnitComponent:init(" .. Table.dump(unitStatics) .. ", " .. tostring(playerId) .. ")")
	self.initialHealth = unitStatics.health
	self.initialDamage = unitStatics.damage
	self.initialDefense = unitStatics.defense
	self.initialWalkSpeed = unitStatics.walkSpeed
end

return UnitComponent
