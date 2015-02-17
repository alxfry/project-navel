local CombatLogic = {}

function CombatLogic.performAttack(actor, target)
    local actorUnitComponent = actor:getComponent("UnitComponent")
    local targetUnitComponent = target:getComponent("UnitComponent")
    
    local damage = actorUnitComponent.damage - targetUnitComponent.defense
    if damage <= 0 then
    	damage = 1
    end
    
    targetUnitComponent.health = targetUnitComponent.health - damage
end

return CombatLogic
