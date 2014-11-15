local Class = require "shared.middleclass"
local BehaviorTree = require "shared.behaviortree"
local Behaviors = require "minionmaster.behaviors.behaviors"

local BehaviorTrees = {}

function BehaviorTrees:createTree()
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

return BehaviorTrees
