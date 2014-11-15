local Class = require "shared.middleclass"

local BehaviorTree = require "shared.behaviortree"
local Behavior = BehaviorTree.Behavior
local STATUS = Behavior.static.STATUS

local state = require "minionmaster.state"

local SearchEnemyBehavior = Class("SearchEnemyBehavior", Behavior)

function SearchEnemyBehavior:update(dt, context)
    print(self)
    
    local object = context.object

    object.target = object:findNearestEnemy(object.position, object.attackRange)
    return STATUS.SUCCESS
	-- return object.target and STATUS.SUCCESS or STATUS.FAILURE
end

local SearchMasterBehavior = Class("SearchMasterBehavior", Behavior)

function SearchMasterBehavior:update(dt, context)
    print(self)
    local object = context.object

    object.target = state.master

    return STATUS.SUCCESS
end

local FindPathBehavior = Class("FindPathBehavior", Behavior)

function FindPathBehavior:update(dt, context)
    print(self)
	local object = context.object

    object:moveTo(object.target.position.x, object.target.position.y)

	return object.waypoints and #object.waypoints > 0 and STATUS.SUCCESS or STATUS.FAILURE
end

local GotoBehavior = Class("GotoBehavior", Behavior)

function GotoBehavior:update(dt, context)
    print(self)
    local object = context.object
    return object:updateMove(dt) and STATUS.RUNNING or STATUS.SUCCESS
end

local AttackBehavior = Class("AttackBehavior", Behavior)

function AttackBehavior:update(dt, context)
    print(self)
    local object = context.object

    local reached, dir, length = object:reachedTarget(dt, object.target.position)

    if length < object.target.spriteSize then
        if not object.attack then
            object:setAnimation("images/minion/frost/attack.png", 0.175)
            object.attack = true
        end
        print("attack")
        object.target.health = object.target.health - 1
        if object.target.health <= 0 then
            return STATUS.SUCCESS
        end
        return STATUS.RUNNING
    elseif object.attack then
        print("walk")
        object.attack = false
        object:setAnimation("images/minion/frost/walk.png", 0.175)
        return STATUS.FAILURE
    end

    return STATUS.SUCCESS
end

return {
    SearchEnemyBehavior = SearchEnemyBehavior,
    SearchMasterBehavior = SearchMasterBehavior,
    FindPathBehavior = FindPathBehavior,
    GotoBehavior = GotoBehavior,
    AttackBehavior = AttackBehavior,
}