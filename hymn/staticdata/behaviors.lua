local Class = require "shared.middleclass"

local BehaviorTree = require "shared.behaviortree"
local Behavior = BehaviorTree.Behavior
local STATUS = Behavior.static.STATUS

local SearchEnemyBehavior = Class("SearchEnemyBehavior", Behavior)

function SearchEnemyBehavior:update(dt, context)
	return STATUS.FAILURE
end

local PathFindBehavior = Class("PathFindBehavior", Behavior)

function PathFindBehavior:update(dt, context)
	local object = context.object
	
end