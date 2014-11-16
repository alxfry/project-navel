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
	-- dbgprint("SearchEnemy")
	return self.status
end

local AttackEnemy = Class("AttackEnemy", Behavior)

function AttackEnemy:start()
	self.attackTick = 0
end

function AttackEnemy:update(dt, context)
	local targetId = context.object.attackTarget
	local enemy = LogicCore.entityManager:entity(targetId)
	local oldStatus = self.status
	self.status = STATUS.FAILURE
	-- if oldStatus ~= STATUS.RUNNING then
	-- 	context.object:setAnimation()
	if enemy then
		self.attackTick = self.attackTick + dt
		if self.attackTick > 1 then
			enemy:takeDamage(1)
			self.attackTick = self.attackTick - 1
		end
		if oldStatus ~= STATUS.RUNNING then
			context.object:setAnimation("attack")
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
	-- dbgprint("PathIdx", object.pathIdx)
	local wpIdx = object.pathIdx
	local currentWp = userPath[wpIdx]
	-- dbgprint("current: " .. wpIdx)
	local nextWp = userPath[wpIdx + 1]
	-- dbgprint("next: " .. wpIdx + 1)
	local reachedWp = true
	if currentWp then
		reachedWp = object.position:add(-userPath[wpIdx]):sqLength() <= 4
	end
	if object.pathIdx == 0 or reachedWp then
		if nextWp then
			-- dbgprint(nextWp.x .. " / " .. nextWp.y)
			-- dbgprint(object.position.x .. " / " .. object.position.y)
			self.status = STATUS.SUCCESS
			object:moveTo(nextWp.x, nextWp.y)
			-- INCREASE PATH TARGET IDX
			object.pathIdx = object.pathIdx + 1
		else
			self.status = STATUS.FAILURE
		end
	else
		-- CORRECT PATH: if target not correctly set update it
		local targetX, targetY = object:getTargetPosition()
		if nextWp and ((targetX ~= nextWp.x) or targetY ~= nextWp.y) then
			object:moveTo(nextWp.x, nextWp.y) 
			self.status = STATUS.SUCCESS
		else
			-- FOUND NO NEXT NODE
			self.status = STATUS.FAILURE
		end
	end
	-- dbgprint("FindWp", self.status, object.pathIdx .. " / " .. #userPath)
	return self.status
end

local MoveTo = Class("MoveTo", Behavior)

function MoveTo:update(dt, context)
	local object = context.object
	local finished = object:updateMove(dt)
	--dbgprint(finished)
	self.status = finished and STATUS.SUCCESS or STATUS.RUNNING
	-- dbgprint(self.status)
	-- dbgprint("MoveTo", self.status)
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
	-- dbgprint("FindConstr", self.status)
	return self.status
end

local WorkConstruction = Class("WorkConstruction", Behavior)

function WorkConstruction:start()
	self.timeWorked = 0
	self.workTime = 0.7
end

function WorkConstruction:update(dt, context)
	local construction = context.closestEntity
	if not (construction and construction.constructing) then
		-- dbgprint(construction)
		if construction then
			-- dbgprint(construction.constructing)
		end
		-- dbgprint("WorkConstruction", STATUS.FAILURE)
		return STATUS.FAILURE
	end
	self.timeWorked = self.timeWorked + dt
	-- dbgprint(self.timeWorked)

	if self.timeWorked >= self.workTime then
		self.timeWorked = self.timeWorked - self.workTime
		construction:addHealth(1)
		-- dbgprint(construction.health)
		-- dbgprint("WorkConstruction", STATUS.SUCCESS)
		return STATUS.SUCCESS
	else
		-- dbgprint("WorkConstruction", STATUS.RUNNING)
		return STATUS.RUNNING
	end
	-- dbgprint("WorkConstr")
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
		local targetPosition = target:closestPosition(object.position)
		object:moveTo(targetPosition.x, targetPosition.y)
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
	if target.owner == context.object.player and target.claims[target.owner.playerId] >= 100 then
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