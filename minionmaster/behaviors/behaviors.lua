local Class = require "shared.middleclass"

local BehaviorTree = require "shared.behaviortree"
local Behavior = BehaviorTree.Behavior
local STATUS = Behavior.static.STATUS

local state = require "minionmaster.state"

local SearchEnemyBehavior = Class("SearchEnemyBehavior", Behavior)

function SearchEnemyBehavior:update(dt, context)
    local object = context.object

    object.target = object:findNearestEnemy(object.position, object.attackRange)
    self.status = object.target and STATUS.SUCCESS or STATUS.FAILURE
    -- print(object.target)
	return self.status
end

local SearchMasterBehavior = Class("SearchMasterBehavior", Behavior)

function SearchMasterBehavior:update(dt, context)
    local object = context.object
    object.target = state.master
    -- print("master")
    self.status = STATUS.SUCCESS
    return self.status
end

local FindPathBehavior = Class("FindPathBehavior", Behavior)

function FindPathBehavior:update(dt, context)
	local object = context.object

    object:moveTo(object.target.position.x, object.target.position.y, object.target.spriteSize)

    self.status = object.waypoints and #object.waypoints > 0 and STATUS.SUCCESS or STATUS.FAILURE
    return self.status
end

local GotoBehavior = Class("GotoBehavior", Behavior)

function GotoBehavior:update(dt, context)
    local object = context.object
    self.status = object:updateMove(dt) and STATUS.FAILURE or STATUS.SUCCESS
    return self.status
end

local AttackBehavior = Class("AttackBehavior", Behavior)

function AttackBehavior:update(dt, context)
    local object = context.object

    local reached, dir, length = object:reachedTarget(object.target.position, dt * object.speed)

    if length < object.target.spriteSize then
        object.attack = true

        -- print(object.target.type)

        if object.target.health <= 0 then
            object.attack = false
            self.status = STATUS.SUCCESS
            -- print("dead")
            return self.status
        end
        self.status = STATUS.RUNNING
    else
        -- print("stop attacking")
        object.attack = false
        self.status = STATUS.FAILURE
    end

    return self.status
end

return {
    SearchEnemyBehavior = SearchEnemyBehavior,
    SearchMasterBehavior = SearchMasterBehavior,
    FindPathBehavior = FindPathBehavior,
    GotoBehavior = GotoBehavior,
    AttackBehavior = AttackBehavior,
}