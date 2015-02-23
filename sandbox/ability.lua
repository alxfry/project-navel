local Class = require "smee.libs.middleclass"

local Ability = Class "Ability"

Ability.TargetType = {
    Self = 1,
    Friend = 2,
    Foe = 4,
    Position = 8,
}

Ability.Application = {
    Single = 1,
    Area = 2,
    Count = 4,
    Jumping = 8,
}

Ability.AttachType = {
    AttachTo = 1,
    Stationary = 2,
}



function Ability:initialize(name, params)
    assert(params.targetType, "No target type set")
    assert(params.effects, "No effects table set")
    for key, val in pairs(params) do
        self[key] = val
    end
    self.name = name
    self.
end