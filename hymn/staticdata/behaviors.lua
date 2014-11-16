local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"
local LogicCore = require "hymn.logiccore"

local BehaviorTree = require "shared.behaviortree"
local Behavior = BehaviorTree.Behavior
local STATUS = Behavior.static.STATUS

local SearchEnemy = Class("SearchEnemy", Behavior)

function SearchEnemy:update(dt, context)
	local object = context.object

	local function isEnemy(entity)
		return entity.player ~= object.player
	end

	local target = object.attackTarget and LogicCore.entityManager:entity(object.attackTarget)
	local distance

	self.status = STATUS.FAILURE

	if target then
		distance = 42
	else
		target, distance = LogicCore.entityManager:findClosestEntity(object.position, isEnemy, 400)
	end

	if target then
		if distance > 40 then
			object:moveTo(target.position.x, target.position.y)
			self.status = STATUS.SUCCESS
		else
			object.attackTarget = target.id
			self.status = STATUS.SUCCESS
		end
	end

	dbgprint("SearchEnemy", self.status)
	return self.status
end

local AttackEnemy = Class("AttackEnemy", Behavior)

function AttackEnemy:update(dt, context)
	local targetId = context.object.attackTarget
	local entity = LogicCore.entityManager:entity(targetId)
	self.status = STATUS.FAILURE
	if entity then
		entity:takeDamage(dt * 0.2)
		self.status = STATUS.RUNNING
	else
		self.attackTarget = false
	end

	dbgprint("AttackEnemy", self.status)
	return self.status
end

local FindWaypoint = Class("FindWaypoint", Behavior)

function FindWaypoint:update(dt, context)
	local object = context.object
	local userPath = object.userPath
	object.pathIdx = object.pathIdx or 0
	wpIdx = object.pathIdx
	if wpIdx == 0 or object.position:add(-userPath[wpIdx]):sqLength() <= 4 then
		wpIdx = wpIdx + 1
		local nextWp = userPath[wpIdx]
		if nextWp then
			self.status = STATUS.SUCCESS
			object.pathIdx = wpIdx
			object:moveTo(nextWp.x, nextWp.y)
		else
			self.status = STATUS.FAILURE
		end
	else
		self.status = STATUS.SUCCESS
	end

	dbgprint("FindWaypoint", self.status)
	return self.status
end

local MoveTo = Class("MoveTo", Behavior)

function MoveTo:update(dt, context)
	local object = context.object
	local finished = object:updateMove(dt)
	self.status = finished and STATUS.FAILURE or STATUS.SUCCESS
	dbgprint("MoveTo", self.status)
	return self.status
end

local RandomMovement = Class("RandomMovement", Behavior)

function RandomMovement:start()
	self.orientation = math.random() * math.pi * 2
end

function RandomMovement:update(dt, context)
	local object = context.object
	local length = 5
	self.orientation = self.orientation + (math.random()-0.5) * math.pi/8
	local alpha = self.orientation
	local direction = GameMath.Vector2:new(math.cos(alpha) * length, math.sin(alpha) * length)
	local newPosition = object.position + direction
	-- dbgprint(object.id, self.orientation)

	object:moveTo(newPosition.x, newPosition.y)
	local finished = object:updateMove(dt)
	dbgprint("RandomMovement")
	return STATUS.RUNNING
end

local FindConstruction = Class("FindConstruction", Behavior)

function FindConstruction:update(dt, context)
	
end

return 
{
	FindWaypoint = FindWaypoint,
	MoveTo = MoveTo,
	RandomMovement = RandomMovement,
	SearchEnemy = SearchEnemy,
	AttackEnemy = AttackEnemy,
}