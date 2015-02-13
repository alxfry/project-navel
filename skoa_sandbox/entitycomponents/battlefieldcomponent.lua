local Entity = require "smee.game_core.entity"
local EntityComponent = require "smee.game_core.entitycomponent"
local UnitComponent = require "skoa_sandbox.entitycomponents.unitcomponent"
local EntityDefinitions = require "skoa_sandbox.statics.entitydefinitions"
local Table = require "skoa_sandbox.utl.table"

local BattlefieldComponent = EntityComponent:subclass("BattlefieldComponent")

function BattlefieldComponent:init(owner, battlefieldStatics, playerId)
	print("BattlefieldComponent:init(" .. tostring(battlefieldStatics) .. ", " .. tostring(playerId) .. ")")

	self.units = {}
    local entityManager = SMEE.GetGame().entityManager
	-- Instantiate units.
	for i, unitDescription in ipairs(battlefieldStatics.units) do
		local newUnit = Entity.static.createFromEStat(EntityDefinitions[unitDescription.unitId], 1)
		newUnit:initPosition(unitDescription.pos[1], unitDescription.pos[2])
        entityManager:add(newUnit)
		self.units[#self.units + 1] = newUnit
		dbgprint("Added new unit at: " .. Table.dump(unitDescription.pos))
	end
end

return BattlefieldComponent