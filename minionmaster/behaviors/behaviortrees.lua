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
    local searchAttackMaster = BehaviorTree.Sequence:new()
    local searchAttackMinion = BehaviorTree.Sequence:new()

    root:addChild(searchAttackMaster)
        searchAttackEnemy:addChild(Behaviors.SearchMasterBehavior:new())
        searchAttackEnemy:addChild(Behaviors.FindPathBehavior:new())
        searchAttackEnemy:addChild(Behaviors.GotoBehavior:new())
        searchAttackEnemy:addChild(Behaviors.AttackBehavior:new())
    root:addChild(searchAttackMinion)
        searchAttackMaster:addChild(Behaviors.SearchMinionBehavior:new())
        searchAttackMaster:addChild(Behaviors.FindPathBehavior:new())
        searchAttackMaster:addChild(Behaviors.GotoBehavior:new())
        searchAttackMaster:addChild(Behaviors.AttackBehavior:new())

    return root
end

return BehaviorTrees
