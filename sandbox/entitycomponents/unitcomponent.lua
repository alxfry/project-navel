local EntityComponent = require "smee.game_core.entitycomponent"
local Table = require "sandbox.utl.table"

local UnitComponent = EntityComponent:subclass("UnitComponent")

function UnitComponent:init(owner, unitStatics)
    EntityComponent.init(self, owner)
	
    self.name = unitStatics.name
    
    self.health = unitStatics.health
    self.damage = unitStatics.damage
    self.attackRange = unitStatics.attackRange
    self.defense = unitStatics.defense
    self.walkRate = unitStatics.walkRate
    self.initiative = unitStatics.initiative
    self.curActionPts = unitStatics.maxActionPts
    self.maxActionPts = unitStatics.maxActionPts

    self.initialHealth = unitStatics.health
    self.initialDamage = unitStatics.damage
    self.initialAttackRange = unitStatics.attackRange
    self.initialDefense = unitStatics.defense
    self.initialwalkRate = unitStatics.walkRate
end

function UnitComponent:getMaxMoveDistance()
    return (self.walkRate or 0) * (self.curActionPts or 0)
end

function UnitComponent:payAP(num)
    if (self.curActionPts - num) >= 0 then
        self.curActionPts = self.curActionPts - num
        return true
    else
        return false
    end
end

return UnitComponent
