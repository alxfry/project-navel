local GameMath              = require "smee.logic.gamemath"
local CollisionComponent    = require "sandbox.entitycomponents.collisioncomponent"

local CombatLogic = {}

function CombatLogic.performMove(encounter, actor, newPos)
    local actorUnitComponent = actor:getComponent("UnitComponent")
    local distance = GameMath.Vector2.distance(newPos, actor.position)

    -- If distance is greater than walk distance, we go as much as we can.
    if distance > actorUnitComponent.walkSpeed then
        local direction = newPos - actor.position
        direction:normalize()
        direction = direction * actorUnitComponent.walkSpeed
        newPos = direction + actor.position
    end

    -- Search for any units which are over target position.
    local nearEntities = CollisionComponent.static.findCloseEntities(newPos)
    if #nearEntities == 1 then
        newPos = CollisionComponent.static.closestPosition(nearEntities[1], newPos)
    elseif #nearEntities > 1 then
        return
    end

    actor.position.x = newPos.x
    actor.position.y = newPos.y
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
