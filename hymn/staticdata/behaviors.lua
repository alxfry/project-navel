local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"

local BehaviorTree = require "shared.behaviortree"
local Behavior = BehaviorTree.Behavior
local STATUS = Behavior.static.STATUS

local SearchEnemyBehavior = Class("SearchEnemyBehavior", Behavior)

function SearchEnemyBehavior:update(dt, context)
	return STATUS.FAILURE
end

local FindWaypoint = Class("FindWaypoint", Behavior)

function FindWaypoint:update(dt, context)
	local object = context.object
	local userPath = object.userPath
	context.waypointIdx = context.waypointIdx or 1
	wpIdx = wpIdx

	if object.position:add(-userPath[wpIdx]):sqLength() <= 4 then
		wpIdx = wpIdx + 1
		local nextWp = userPath[wpIdx]
		if nextWp then
			self.status = STATUS.SUCCESS
			context.waypointIdx = wpIdx
			object:moveTo(nextWp.x, nextWp.y)
		else
			self.status = STATUS.FAILURE
		end
	else
		self.status = STATUS.SUCCESS
	end

	return self.status
end

local MoveTo = Class("MoveTo", Behavior)

function MoveTo:update(dt, context)
	local object = context.object

	local finished = object:updateMove(dt)
	self.status = finished and STATUS.FAILURE or STATUS.SUCCESS
	return self.status
end

return 
{
	FindWaypoint = FindWaypoint,
	MoveTo = MoveTo,
}