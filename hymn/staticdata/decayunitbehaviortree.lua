local Class = require "shared.middleclass"
local BehaviorTree = require "shared.behaviortree"
local Behaviors = require "hymn.staticdata.behaviors"

local root = BehaviorTree.Selector:new()
local engageCombat = BehaviorTree.Sequence:new()
local walkToWaypoint = BehaviorTree.Sequence:new()
local randomWalk = BehaviorTree.Sequence:new()

root:addChild(randomWalk)
    randomWalk:addChild(Behaviors.RandomMovement:new())

-- root:addChild(engageCombat)
root:addChild(walkToWaypoint)
	engageCombat:addChild(Behaviors.FindWaypoint:new())
	engageCombat:addChild(Behaviors.MoveTo:new())

return root