local Bitfield = require "smee.util.bitfield"

local Abilities = {}

Abilities.TargetTypes = {
	Self = 1,
	Friend = 2,
	Foe = 4,
	Position = 8,
}

Abilities.EffectTypes = {
	Heal = 1,
}

Abilities.Definitions = {}
Abilities.Definitions.Heal = {
	target = Bitfield:new(Abilities.TargetTypes.Self + Abilities.TargetTypes.Friend),
	range = 270,		-- 4 x unit width
	tier = 1,
	cost = 5,	         -- Unit has 10 action points
	cooldown = 1,        -- Ability can be used every round.  
	icon = "/sandbox/resources/ui_pictures/icon_ability_heal.png",

	effects = {
		{ type = Abilities.EffectTypes.Heal, amount = 50, },
	},
}

for name, data in pairs(Abilities.Definitions) do
	data.name = name
end

return Abilities
