local Class = require "smee.libs.middleclass"
local blocking = require "smee.logic.blocking"
local BehaviorTree = require "smee.logic.behaviortree"
local Behavior = BehaviorTree.Behavior
local STATUS = Behavior.static.STATUS

local state = require "minionmaster.state"

local SearchEnemyBehavior = Class("SearchEnemyBehavior", Behavior)

function SearchEnemyBehavior:update(dt, context)
    local object = context.object

    object.target = object:findNearestEnemy(object.position, object.attackRange)
    self.status = object.target and STATUS.SUCCESS or STATUS.FAILURE
	return self.status
end

local SearchMinionBehavior = Class("SearchMinionBehavior", Behavior)

function SearchMinionBehavior:update(dt, context)
    local object = context.object

    object.target = state.entityManager:findClosestEntity(object.position,
        function(entity)
            return not entity.dead and entity.type == "minion"
        end,
        object.attackRange
        )

    object.moving = object.target

    self.status = object.target and STATUS.SUCCESS or STATUS.FAILURE
    return self.status
end

local SearchMasterBehavior = Class("SearchMasterBehavior", Behavior)

function SearchMasterBehavior:update(dt, context)
    local object = context.object

    if object.type == "minion" or (state.master.position - object.position):sqLength() < object.attackRange * object.attackRange then
        object.target = state.master
        self.status = STATUS.SUCCESS
    else
        self.status = STATUS.FAILURE
    end
    return self.status
end

local SearchNearestBehavior = Class("SearchNearestBehavior", Behavior)

function SearchNearestBehavior:update(dt, context)
    local object = context.object

    object.target = state.entityManager:findClosestEntity(object.position,
        function(entity)
            return not entity.dead and entity.type == "master" or entity.type == "minion"
        end,
        object.attackRange
        )
    self.status = object.target and STATUS.SUCCESS or STATUS.FAILURE
    return self.status
end

local GotoTargetBehavior = Class("GotoTargetBehavior", Behavior)

function GotoTargetBehavior:update(dt, context)
    local object = context.object
    object:moveTo(object.target.position, object.target.spriteSize / 2)
    if not object.waypoints or #object.waypoints < 1 then
        self.status = STATUS.FAILURE
    else
        object.moving = true
        self.status = object:updateMove(dt) and STATUS.SUCCESS or STATUS.RUNNING
    end
    return self.status
end

local GotoTargetWithEnemySearchBehavior = Class("GotoTargetWithEnemySearchBehavior", GotoTargetBehavior)

function GotoTargetWithEnemySearchBehavior:initialize()
    self.time = 0
end

function GotoTargetWithEnemySearchBehavior:update(dt, context)
    local object = context.object
    self.time = self.time - dt
    if self.time <= 0 and object.target.type ~= "enemy" then
        local target = object:findNearestEnemy(object.position, object.attackRange)
        self.time = 1
        if target and blocking.pathExists(object.position.x, object.position.y, target.position.x, target.position.y) then
            object.target = target
            self.status = STATUS.FAILURE
        end
    end

    local status = GotoTargetBehavior.update(self, dt, context)

    if self.status ~= STATUS.FAILURE then
        self.status = status
    end
    return self.status
end

local GotoTargetWithMinionSearchBehavior = Class("GotoTargetWithMinionSearchBehavior", GotoTargetBehavior)

function GotoTargetWithMinionSearchBehavior:initialize()
    self.time = 0
end

function GotoTargetWithMinionSearchBehavior:update(dt, context)
    local object = context.object
    self.time = self.time - dt
    if self.time <= 0 and object.target.type ~= "minion" then
        local target = state.entityManager:findClosestEntity(object.position,
            function(entity)
                return not entity.dead and entity.type == "minion"
            end,
            object.attackRange
        )
        self.time = 1
        if target and blocking.pathExists(object.position.x, object.position.y, target.position.x, target.position.y) then
            object.target = target
            self.status = STATUS.FAILURE
        end
    end

    local status = GotoTargetBehavior.update(self, dt, context)

    if self.status ~= STATUS.FAILURE then
        self.status = status
    end
    return self.status
end

local AttackBehavior = Class("AttackBehavior", Behavior)

function AttackBehavior:update(dt, context)
    local object = context.object

    local reached, dir, length = object:reachedTarget(object.target.position, dt * object.speed)

    if length < object.target.spriteSize / 2 then
        object.attack = true

        object.target:takeDamage(object.damage * dt)

        if object.target.health <= 0 then
            object.attack = false
            self.status = STATUS.SUCCESS
            return self.status
        end
        self.status = STATUS.RUNNING
    else
        object.attack = false
        self.status = STATUS.FAILURE
    end

    return self.status
end

return {
    SearchEnemyBehavior = SearchEnemyBehavior,
    SearchMinionBehavior = SearchMinionBehavior,
    SearchMasterBehavior = SearchMasterBehavior,
    SearchNearestBehavior = SearchNearestBehavior,
    GotoTargetBehavior = GotoTargetBehavior,
    GotoTargetWithEnemySearchBehavior = GotoTargetWithEnemySearchBehavior,
    GotoTargetWithMinionSearchBehavior = GotoTargetWithMinionSearchBehavior,
    AttackBehavior = AttackBehavior,
}
