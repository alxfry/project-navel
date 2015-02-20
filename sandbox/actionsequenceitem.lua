local Class = require "smee.libs.middleclass"

local ActionSquenceItem = Class "ActionSequenceItem"

function ActionSequenceItem:initialize(actionType, source, targets, power, position)
    self.actionType = actionType
    self.source = source
    self.targets = targets
    self.power = power
    self.position = position
end