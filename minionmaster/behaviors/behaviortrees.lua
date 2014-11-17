local Class = require "smee.libs.middleclass"
local BehaviorTree = require "smee.logic.behaviortree"
local Behaviors = require "minionmaster.behaviors.behaviors"

local BehaviorTrees = {}

function BehaviorTrees:createMinionTree()
    local root = BehaviorTree.Selector:new()
    local searchAttackEnemy = BehaviorTree.Sequence:new()
    local searchAttackMaster = BehaviorTree.Sequence:new()

    root:addChild(searchAttackEnemy)
        searchAttackEnemy:addChild(Behaviors.SearchEnemyBehavior:new())
        searchAttackEnemy:addChild(Behaviors.GotoTargetBehavior:new())
        searchAttackEnemy:addChild(Behaviors.AttackBehavior:new())
    root:addChild(searchAttackMaster)
        searchAttackMaster:addChild(Behaviors.SearchMasterBehavior:new())
        searchAttackMaster:addChild(Behaviors.GotoTargetWithEnemySearchBehavior:new())
        searchAttackMaster:addChild(Behaviors.AttackBehavior:new())

    return root
end

function BehaviorTrees:createEnemyTree()
    local root = BehaviorTree.Selector:new()
    local searchAttackMinion = BehaviorTree.Sequence:new()
    local searchAttackMaster = BehaviorTree.Sequence:new()

    root:addChild(searchAttackMinion)
        searchAttackMinion:addChild(Behaviors.SearchMinionBehavior:new())
        searchAttackMinion:addChild(Behaviors.GotoTargetBehavior:new())
        searchAttackMinion:addChild(Behaviors.AttackBehavior:new())
    root:addChild(searchAttackMaster)
        searchAttackMaster:addChild(Behaviors.SearchMasterBehavior:new())
        searchAttackMaster:addChild(Behaviors.GotoTargetWithMinionSearchBehavior:new())
        searchAttackMaster:addChild(Behaviors.AttackBehavior:new())

    return root
end

return BehaviorTrees
