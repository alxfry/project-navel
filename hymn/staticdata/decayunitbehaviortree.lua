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
    local walkToWaypoint = BehaviorTree.Sequence:new()
    walkToWaypoint:addChild(Behaviors.FindWaypoint:new())
    walkToWaypoint:addChild(Behaviors.MoveTo:new())

    local findTarget = BehaviorTree.Selector:new()
    findTarget:addChild(Behaviors.SearchEnemy:new())
    findTarget:addChild(Behaviors.FindWaypoint:new())

    local root = BehaviorTree.Sequence:new()
    root:addChild(findTarget)
    root:addChild(Behaviors.MoveTo:new())
    root:addChild(Behaviors.AttackEnemy:new())
    -- root:addChild(Behaviors.RandomMovement:new())

	-- local root = BehaviorTree.Sequence:new()
    -- root:addChild(Behaviors.RandomMovement:new())
-- root:addChild(Behaviors.RandomMovement:new())
-- root:addChild(Behaviors.MoveTo:new())
	return root
end

return createDecayUnitBT