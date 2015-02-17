local CombatLogic = {}

function CombatLogic.performAttack(encounter, actor, target)
    local actorUnitComponent = actor:getComponent("UnitComponent")
    local targetUnitComponent = target:getComponent("UnitComponent")
    
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

return CombatLogic
