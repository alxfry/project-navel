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
-- Absolutely valid BT
    -- local findTarget = BehaviorTree.Selector:new()
    -- findTarget:addChild(Behaviors.SearchEnemy:new())
    -- findTarget:addChild(Behaviors.FindWaypoint:new())
    -- findTarget:addChild(Behaviors.FindConstruction:new())

    -- local root = BehaviorTree.Sequence:new()
    -- root:addChild(findTarget)
    -- root:addChild(Behaviors.MoveTo:new())
    -- root:addChild(Behaviors.AttackEnemy:new())
    -- root:addChild(Behaviors.WorkConstruction:new())

    local root = BehaviorTree.Selector:new()
    local engageCombat = BehaviorTree.Sequence:new()
    local goToPath = BehaviorTree.Sequence:new()
    local constructionJob = BehaviorTree.Sequence:new()

    root:addChild(engageCombat)
    	engageCombat:addChild(Behaviors.SearchEnemy:new())
    	engageCombat:addChild(Behaviors.MoveTo:new())
    	engageCombat:addChild(Behaviors.AttackEnemy:new())
	root:addChild(goToPath)
		goToPath:addChild(Behaviors.FindWaypoint:new())
		goToPath:addChild(Behaviors.MoveTo:new())
	root:addChild(constructionJob)
	 	constructionJob:addChild(Behaviors.FindConstruction:new())
	 	constructionJob:addChild(Behaviors.MoveTo:new())
	 	constructionJob:addChild(Behaviors.WorkConstruction:new())

	return root
end

local function depositDebuggingBT()
    local root = BehaviorTree.Sequence:new()
    root:addChild(Behaviors.FindDeposit:new())
    root:addChild(Behaviors.MoveTo:new())
    root:addChild(Behaviors.ClaimDeposit:new())

    return root
end

return depositDebuggingBT
-- return createDecayUnitBT