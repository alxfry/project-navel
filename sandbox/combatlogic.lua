local GameMath              = require "smee.logic.gamemath"
local CollisionComponent    = require "sandbox.entitycomponents.collisioncomponent"

local CombatLogic = {}

function CombatLogic.performMove(encounter, actor, newPos)
    local actorUnitComponent = actor:getComponent("UnitComponent")
    local actorMoveComponent = actor:getComponent("MovementComponent")
    local distance = GameMath.Vector2.distance(newPos, actor.position)
    local maxDistance = actorUnitComponent.walkRate * actorUnitComponent.curActionPts
    -- If distance is greater than walk distance, we go as much as we can.
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
    if distance <= actorUnitComponent.attackRange then
        local damage = actorUnitComponent.damage - targetUnitComponent.defense
        if damage <= 0 then
        	damage = 1
        end
        
        targetUnitComponent.health = targetUnitComponent.health - damage
        if targetUnitComponent.health <= 0 then
        	-- Remove entity from battlefield component.
            local battlefieldComponent = encounter:getComponent("BattlefieldComponent")
        	battlefieldComponent:removeEntity(target)
        end
    end
end

return CombatLogic
