local Class = require "shared.middleclass"
local BehaviorTree = require "shared.behaviortree"
local Behaviors = require "minionmaster.behaviors.behaviors"

local root = BehaviorTree.Selector:new()
local searchAttackEnemy = BehaviorTree.Sequence:new()
local searchAttackMaster = BehaviorTree.Sequence:new()

root:addChild(searchAttackEnemy)
    searchAttackEnemy:addChild(Behaviors.SearchEnemyBehavior)
    searchAttackEnemy:addChild(Behaviors.FindPathBehavior)
    searchAttackEnemy:addChild(Behaviors.GotoBehavior)
    searchAttackEnemy:addChild(Behaviors.AttackBehavior)
root:addChild(searchAttackMaster)
    searchAttackMaster:addChild(Behaviors.SearchMasterBehavior)
    searchAttackMaster:addChild(Behaviors.FindPathBehavior)
    searchAttackMaster:addChild(Behaviors.GotoBehavior)
    searchAttackMaster:addChild(Behaviors.AttackBehavior)

return root
