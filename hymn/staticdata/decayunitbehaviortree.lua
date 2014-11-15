local Class = require "shared.middleclass"
local BehaviorTree = require "shared.behaviortree"
local Behaviors = require "hymn.staticdata.behaviors"

-- local root = BehaviorTree.Selector:new()
-- local engageCombat = BehaviorTree.Sequence:new()
-- local walkToWaypoint = BehaviorTree.Sequence:new()
-- local randomWalk = BehaviorTree.Sequence:new()

-- root:addChild(randomWalk)
--     randomWalk:addChild(Behaviors.RandomMovement:new())
local function createDecayUnitBT()
	local root = BehaviorTree.Sequence:new()
	root:addChild(Behaviors.RandomMovement:new())
-- root:addChild(Behaviors.FindWaypoint:new())
-- root:addChild(Behaviors.MoveTo:new())
	return root
end

return createDecayUnitBT