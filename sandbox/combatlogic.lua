local GameMath              = require "smee.logic.gamemath"
local CollisionComponent    = require "sandbox.entitycomponents.collisioncomponent"
local Abilities             = require "sandbox.statics.abilitiydefinitions"

local CombatLogic = {}

local function applyEffect(effect, target)
    local targetUnitComponent = target:getComponent("UnitComponent")
    
    -- if effect.type == Abilities.EffectTypes.Heal then
    -- 	targetUnitComponent.health = targetUnitComponent.health + effect.amount
    -- 	if targetUnitComponent.health > targetUnitComponent.initialHealth then
    -- 		targetUnitComponent.health = targetUnitComponent.initialHealth
    -- 	end
    -- end
end

function CombatLogic.applyAbilityOnPosition(currentEncounter, actor, abilityName, clickPos)
    local abilityDefinition = Abilities.Definitions[abilityName]

    -- Check, if target is valid.
    if not abilityDefinition.target:isSet(Abilities.TargetTypes.Position) then
        dbgprint("Cannot apply ability on a position!")
        return
    end
end

function CombatLogic.applyAbilityOnEntity(currentEncounter, actor, abilityName, target)
    local actorUnitComponent = actor:getComponent("UnitComponent")
    local abilityDefinition = Abilities.Definitions[abilityName]
    
    -- Check, if target is valid.
    local targetIsValid = false
    if actor == target then
    	-- Target type must cobtain 'Self'.
    	if abilityDefinition.target:isSet(Abilities.TargetTypes.Self) then
    		targetIsValid = true
    	end
    else
        -- actor != target
        --TODO AMD: Check for friend/foe
        if abilityDefinition.target:isSet(Abilities.TargetTypes.Friend + Abilities.TargetTypes.Foe) then
            targetIsValid = true
        end
    end
    
    if not targetIsValid then
    	dbgprint("Not a valid target!")
    	return
    end
    
    -- Check, if we have enough action points.
    if actorUnitComponent.base.actionPts < abilityDefinition.cost then
    	dbgprint("Not enough action points!!")
    	return
    end
    
    -- Check, if target is in range.
    local distance = GameMath.Vector2.distance(target.position, actor.position)
    if distance > abilityDefinition.range then
        dbgprint("Target is too far away!")
        return
    end
    
    actorUnitComponent.base.actionPts = actorUnitComponent.base.actionPts - abilityDefinition.cost

    for idx, effect in ipairs(abilityDefinition.effects) do
    	applyEffect(effect, target)
    end
end

function CombatLogic.performMove(encounter, actor, newPos)
    local actorUnitComponent = actor:getComponent("UnitComponent")
    local actorMoveComponent = actor:getComponent("MovementComponent")
    local maxDistance = actorUnitComponent.current.walkRate * actorUnitComponent.base.actionPts
    -- If distance is greater than walk distance, we go as much as we can.
    local distance = GameMath.Vector2.distance(newPos, actor.position)
    if distance > maxDistance then
        local direction = newPos - actor.position
        direction:normalize()
        direction = direction * maxDistance
        distance = maxDistance
        newPos = direction + actor.position
    end

    -- Search for any units which are over target position.
    local nearEntities = CollisionComponent.static.findCloseEntities(newPos, {[actor.id] = true})
    if #nearEntities == 1 then
        newPos = CollisionComponent.static.closestPosition(nearEntities[1], actor.position)
        distance = GameMath.Vector2.distance(newPos, actor.position)
    elseif #nearEntities > 1 then
        return
    end

    local apCost = actorMoveComponent:getDistanceInAP(distance)
    if actorUnitComponent:payAP(apCost) then
        actorMoveComponent:moveTo(newPos)
    end
end

function CombatLogic.performAttack(encounter, actor, target)
    local actorUnitComponent = actor:getComponent("UnitComponent")
    local targetUnitComponent = target:getComponent("UnitComponent")
    
    local distance = GameMath.Vector2.distance(actor.position, target.position)
    if distance <= actorUnitComponent.current.attackRange then
        local damage = actorUnitComponent.current.damage - targetUnitComponent.current.defense
        if damage <= 0 then
        	damage = 1
        end
        
        targetUnitComponent.base.health = targetUnitComponent.base.health - damage
    end
end

return CombatLogic
