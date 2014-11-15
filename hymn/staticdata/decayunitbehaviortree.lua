local Class = require "shared.middleclass"
local BehaviorTree = require "shared.behaviortree"

local root = BehaviorTree.Selector:new()
local engageCombat = BehaviorTree.Sequence:new()
local walkToWaypoint = BehaviorTree.Sequence:new()

root:addChild(engageCombat)
root:addChild(walkToWaypoint)

