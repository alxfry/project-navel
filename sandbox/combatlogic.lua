local GameMath =    require "smee.logic.gamemath"

local CombatLogic = {}

function CombatLogic.performMove(encounter, actor, newPos)
    local actorUnitComponent = actor:getComponent("UnitComponent")
    local distance = GameMath.Vector2.distance(newPos, actor.position)
    if distance <= actorUnitComponent.walkSpeed then
        actor.position.x = newPos.x
        actor.position.y = newPos.y
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
