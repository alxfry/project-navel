local Class = require "smee.libs.middleclass"

local Ability = Class "Ability"

Ability.TargetFaction =
{
    Friend = 1,
    Foe = 2,
}

Ability.TargetType = {
    Self = 1,
    Friend = 2,
    Foe = 4,
    Position = 8,
}

Ability.EffectApplication = {
    Single = 1,
    Area = 2,
    Count = 4,
    Jumping = 8,
}

-- Ability.

function Ability:initialize(name, params)
    assert(params.targetType, "No target type set")
    assert(params.effects, "No effects table set")
    for key, val in pairs(params) do
        self[key] = val
    end
    self.name = name
    self.
end