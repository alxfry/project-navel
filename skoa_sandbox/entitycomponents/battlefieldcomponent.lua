local Entity = require "smee.game_core.entity"
local EntityComponent = require "smee.game_core.entitycomponent"
local UnitComponent = require "skoa_sandbox.entitycomponents.unitcomponent"
local EntityDefinitions = require "skoa_sandbox.statics.entitydefinitions"

local BattlefieldComponent = EntityComponent:subclass("BattlefieldComponent")

function BattlefieldComponent:init(owner, battlefieldStatics, playerId)
	print("BattlefieldComponent:init(" .. tostring(battlefieldStatics) .. ", " .. tostring(playerId) .. ")")

	self.units = {}

	-- Instantiate units.
	for i, unitDescription in ipairs(battlefieldStatics.units) do
		local newUnit = Entity.static.createFromEStat(EntityDefinitions[unitDescription.unitId], 1)
		self.units[#self.units + 1] = newUnit
		print("Added unit '" .. unitDescription.unitId .. "' to battlefield")
	end
end

return BattlefieldComponent