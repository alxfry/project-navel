local Class = require "shared.middleclass"
local BehaviorTree = require "shared.behaviortree"
local Behaviors = require "minionmaster.behaviors.behaviors"

local BehaviorTrees = {}

function BehaviorTrees:createMinionTree()
    local root = BehaviorTree.Selector:new()
    local searchAttackEnemy = BehaviorTree.Sequence:new()
    local searchAttackMaster = BehaviorTree.Sequence:new()

    root:addChild(searchAttackEnemy)
        searchAttackEnemy:addChild(Behaviors.SearchEnemyBehavior:new())
        searchAttackEnemy:addChild(Behaviors.FindPathBehavior:new())
        searchAttackEnemy:addChild(Behaviors.GotoBehavior:new())
        searchAttackEnemy:addChild(Behaviors.AttackBehavior:new())
    root:addChild(searchAttackMaster)
        searchAttackMaster:addChild(Behaviors.SearchMasterBehavior:new())
        searchAttackMaster:addChild(Behaviors.FindPathBehavior:new())
        searchAttackMaster:addChild(Behaviors.GotoBehavior:new())
        searchAttackMaster:addChild(Behaviors.AttackBehavior:new())

    return root
end

function BehaviorTrees:createEnemyTree()
    local root = BehaviorTree.Selector:new()
    local searchAttackNearest = BehaviorTree.Sequence:new()
    
    root:addChild(searchAttackNearest)
        searchAttackNearest:addChild(Behaviors.SearchNearestBehavior:new())
        searchAttackNearest:addChild(Behaviors.FindPathBehavior:new())
        searchAttackNearest:addChild(Behaviors.GotoBehavior:new())
        searchAttackNearest:addChild(Behaviors.AttackBehavior:new())

    return root
end

return BehaviorTrees
