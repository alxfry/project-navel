local EntityComponent = require "smee.game_core.entitycomponent"
local Table = require "sandbox.utl.table"

local UnitComponent = EntityComponent:subclass("UnitComponent")

function UnitComponent:initialize(owner)
    EntityComponent.initialize(self, owner)
    self.max = {}
    self.base = {}
    self.current = {}
    self.effects = {}
end

function UnitComponent:init(owner, unitStatics)
    EntityComponent.init(self, owner)
	
    self.type = unitStatics.name
    self.name = unitStatics.name

    for k, v in pairs(unitStatics) do
        self.max[k] = v
        self.base[k] = v
        self.current[k] = v
    end
    self.base.actionPts = 0

    
    -- self.health = unitStatics.health
    -- self.damage = unitStatics.damage
    -- self.attackRange = unitStatics.attackRange
    -- self.defense = unitStatics.defense
    -- self.walkRate = unitStatics.walkRate
    -- self.initiative = unitStatics.initiative
    -- self.baseActionPts = unitStatics.baseActionPts
    -- self.maxActionPts = unitStatics.maxActionPts

    -- self.initialHealth = unitStatics.health
    -- self.initialDamage = unitStatics.damage
    -- self.initialAttackRange = unitStatics.attackRange
    -- self.initialDefense = unitStatics.defense
    -- self.initialWalkRate = unitStatics.walkRate
end

function UnitComponent:update(dt)
    self:updateStats()
    -- Check alive
    if self.current.health <= 0 then
        -- Remove entity from battlefield component.
        self.dead = true
    end
end

function UnitComponent:getCur(key)
    return self.current[key]
end

function UnitComponent:getInitial(key)
    return self.max[key]
end

function UnitComponent:getMaxMoveDistance()
    return (self.current.walkRate or 0) * (self.base.actionPts or 0)
end

function UnitComponent:payAP(num)
    if (self.base.actionPts - num) >= 0 then
        self.base.actionPts = self.base.actionPts - num
        return true
    else
        return false
    end
end

function UnitComponent:updateStats()
    for k, v in pairs(self.current) do
        self.current[k] = self.base[k]
    end
    for i = 1, #self.effects do
        local effect = effects[i]
        
    end
end

return UnitComponent
