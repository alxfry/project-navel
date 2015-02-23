local Class = require "smee.libs.middleclass"

local CombatEffect = Class "CombatEffect"

local function hasRunOutInstant(effect, roundUpdate)
    return true
end

local function hasRunOutDuration(effect, roundUpdate)
    if roundUpdate then
        effect.duration = duration-1
        if duration <= 0 then
            return true
        end
    end
    return false
end

local function hasRunOutLasting(effect, roundUpdate)
    return false
end

local function effectAddToCurrentFlat(entity, effect)
    local unitCmp = entity:getComponent("UnitComponent")
    assert(unitCmp, "effect can only be applied on a unit with a unit component")
    
    local targetStat = effect.params.targetStat
    unitCmp.base[targetStat] = unitCmp.base[targetStat] + effect:getPower()
end

local function effectAddToCurrentPerc(entity, effect)
    local unitCmp = entity:getComponent("UnitComponent")
    assert(unitCmp, "effect can only be applied on a unit with a unit component")

    local targetStat = effect.params.targetStat
    local percToAdd = unitCmp.base[targetStat] * effect:getPower()
    unitCmp.base[targetStat] = unitCmp.base[targetStat] + percToAdd
end

local function effectModifyCurrentFlat(entity, effect)
    local unitCmp = entity:getComponent("UnitComponent")
    assert(unitCmp, "effect can only be applied on a unit with a unit component")

    local targetStat = effect.params.targetStat
    unitCmp.current[targetStat] = unitCmp.current[targetStat] + effect:getPower()
end

local function effectModifyCurrentPerc(entity, effect)
    local unitCmp = entity:getComponent("UnitComponent")
    assert(unitCmp, "effect can only be applied on a unit with a unit component")

    local targetStat = effect.params.targetStat
    local percToAdd = unitCmp.current[targetStat] * effect:getPower()
    unitCmp.current[targetStat] = unitCmp.current[targetStat] + percToAdd
end

local function effectModifyMaximumFlat(entity, effect)
    local unitCmp = entity:getComponent("UnitComponent")
    assert(unitCmp, "effect can only be applied on a unit with a unit component")

    local targetStat = effect.params.targetStat
    unitCmp.max[targetStat] = unitCmp.max[targetStat] + effect:getPower()
end

local function effectModifyMaximumPerc(entity, effect)
    local unitCmp = entity:getComponent("UnitComponent")
    assert(unitCmp, "effect can only be applied on a unit with a unit component")

    local targetStat = effect.params.targetStat
    local percToAdd = unitCmp.max[targetStat] * effect:getPower()
    unitCmp.max[targetStat] = unitCmp.max[targetStat] + percToAdd
end

CombatEffect.Type = {
    AddToCurrentFlat    = "AddToCurrentFlat",
    AddToCurrentPerc    = "AddToCurrentPerc",
    ModifyCurrentFlat   = "ModifyCurrentFlat",
    ModifyCurrentPerc   = "ModifyCurrentPerc",
    ModifyMaximumFlat   = "ModifyMaximumFlat",
    ModifyMaximumPerc   = "ModifyMaximumPerc",
    Summon              = "Summon",
    Stun                = "Stun",
}

CombatEffect.Application = {
    Instant = 1,        -- Always has a duration of 0
    Interval = 2,       -- Over Time
    Duration = 4,       -- 
    WhileAttached = 8,
}

CombatEffect.hasRunOut = {
    [CombatEffect.Application.Instant] = hasRunOutInstant,
    [CombatEffect.Application.Interval] = hasRunOutDuration,
    [CombatEffect.Application.Duration] = hasRunOutDuration,
    [CombatEffect.Application.WhileAttached] = hasRunOutLasting,
}

CombatEffect.applyEffect = {
    [CombatEffect.Type.AddToCurrentFlat] = effectAddToCurrentFlat,
}

function CombatEffect:initialize()
    self.onExpire = {}
    self.onEntityDeath = {}
    self.onDispel = {}
    self.onRoundUpdate = {}
end

function CombatEffect:onExpire(func)
    self.onExpire[#self.onExpire+1] = func
end

function CombatEffect:onEntityDeath(func)
    self.onEntityDeath[#self.onEntityDeath+1] = func
end

function CombatEffect:onDispel(func)
    self.onDispel[#self.onDispel] = func
end

function CombatEffect:onRoundUpdate(func)
    self.onRoundUpdate[#self.onRoundUpdate+1] = func
end

function CombatEffect:getPower()
    return self.params.power
end

function CombatEffect:apply(entity, roundUpdate)
    for i = 1, #self.onRoundUpdate do
        self.onRoundUpdate[i](entity, effect)
    end

    if self.application == CombatEffect.Application.Instant or 
       self.application == CombatEffect.Application.Interval and roundUpdate or
       self.application == CombatEffect.Application.Duration or
       self.application == CombatEffect.Application.WhileAttached then
        CombatEffect.applyEffect[self.type](entity, self)
    end

    return CombatEffect.hasRunOut[self.application](self, roundUpdate)
end

return CombatEffect