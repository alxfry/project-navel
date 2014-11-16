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
		return entity.player and entity.player ~= object.player
	end

	local target = object.attackTarget and LogicCore.entityManager:entity(object.attackTarget)
	local distance

	self.status = STATUS.FAILURE

	if target then
		distance = 22
	else
		target, distance = LogicCore.entityManager:findClosestEntity(object.position, isEnemy, 400)
	end

	if target then
		if distance > 20 then
			object:moveTo(target.position.x, target.position.y)
			self.status = STATUS.SUCCESS
		else
			object.attackTarget = target.id
			self.status = STATUS.SUCCESS
		end
	end

	return self.status
end

local AttackEnemy = Class("AttackEnemy", Behavior)

function AttackEnemy:start()
	self.attackTick = 0
end

function AttackEnemy:update(dt, context)
	local targetId = context.object.attackTarget
	local entity = LogicCore.entityManager:entity(targetId)
	self.status = STATUS.FAILURE
	if entity then
		self.attackTick = self.attackTick + dt
		if self.attackTick > 1 then
			entity:takeDamage(1)
			self.attackTick = self.attackTick - 1
		end
		self.status = STATUS.RUNNING
	else
		self.attackTarget = false
	end

	-- dbgprint("AttackEnemy", self.status)
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

	return self.status
end

local MoveTo = Class("MoveTo", Behavior)

function MoveTo:update(dt, context)
	local object = context.object
	local finished = object:updateMove(dt)
	self.status = finished and STATUS.SUCCESS or STATUS.RUNNING

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
	
	return STATUS.RUNNING
end

local FindConstruction = Class("FindConstruction", Behavior)

function FindConstruction:update(dt, context)
	local Building = require "shared.building"
	local object = context.object
	local player = object.player
	
	local function predicate(entity)
		if entity:isInstanceOf(Building) 
		   and entity.constructing 
		   and entity.player == player then
			return true
		else
			return false
		end
	end

	local closestEntity, distance = LogicCore.entityManager:findClosestEntity(object.position, predicate)

	if closestEntity then
		object:moveTo(closestEntity.position.x, closestEntity.position.y)
		context.closestEntity = closestEntity
		self.status = STATUS.SUCCESS
	else
		self.status = STATUS.FAILURE
	end

	return self.status
end

local WorkConstruction = Class("WorkConstruction", Behavior)

function WorkConstruction:start()
	self.timeWorked = 0
	self.workTime = 0.7
end

function WorkConstruction:update(dt, context)
	local construction = context.closestEntity
	if not construction or not construction.constructing then
		dbgprint(construction)
		if construction then
			dbgprint(construction.constructing)
		end
		return STATUS.FAILURE
	end
	self.timeWorked = self.timeWorked + dt
	dbgprint(self.timeWorked)

	if self.timeWorked >= self.workTime then
		self.timeWorked = self.timeWorked - self.workTime
		construction:addHealth(1)
		return STATUS.SUCCESS
	else
		return STATUS.RUNNING
	end
end

local FindDeposit = Class("FindDeposit", Behavior)

function FindDeposit:update(dt, context)
	local Deposit = require "hymn.deposit"
	local object = context.object
	local player = object.player
	
	local function isClaimableDeposit(entity)
		return entity:isInstanceOf(Deposit) and entity.claims[player.playerId] < 100
	end

	local target, distance = LogicCore.entityManager:findClosestEntity(object.position, isClaimableDeposit)

	if target then
		object:moveTo(target.position.x, target.position.y)
		context.closestDeposit = target
		self.status = STATUS.SUCCESS
	else
		self.status = STATUS.FAILURE
	end

	return self.status
end

local ClaimDeposit = Class("ClaimDeposit", Behavior)

function ClaimDeposit:start()
	self.timeWorked = 0
	self.workTime = 0.2
end

function ClaimDeposit:update(dt, context)
	local target = context.closestDeposit
	if not target then
		return STATUS.FAILURE
	end
	self.timeWorked = self.timeWorked + dt

	if self.timeWorked >= self.workTime then
		self.timeWorked = self.timeWorked - self.workTime
		target:claim(context.object, 1)
		return STATUS.SUCCESS
	else
		return STATUS.RUNNING
	end
end

return 
{
	FindWaypoint 		= FindWaypoint,
	MoveTo 				= MoveTo,
	RandomMovement 		= RandomMovement,
	SearchEnemy 		= SearchEnemy,
	FindConstruction 	= FindConstruction,
	WorkConstruction	= WorkConstruction,
	SearchEnemy = SearchEnemy,
	AttackEnemy = AttackEnemy,
	FindDeposit = FindDeposit,
	ClaimDeposit = ClaimDeposit,
}