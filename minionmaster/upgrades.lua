local state = require "minionmaster.state"

local UpgradeStatics = 
{
    healMaster =
    {
        entityType = "master",
        param = "health",
        value = 10,
        cost = 10,
        name = "healMaster",
    },

    minionCostDown =
    {
        entityType = "minion",
        param = "cost",
        value = -1,
        cost = 10,
        name = "minionCostDown",
    },

    damageUpMinion =
    {
        entityType = "minion",
        param = "damage",
        value = 1,
        cost = 10,
        name = "damageUpMinion",
    },

    healthUpMinion =
    {
        entityType = "minion",
        param = "health",
        value = 2,
        cost = 5,
        name = "healthUpMinion",
    },

    damageDownEnemy =
    {
        entityType = "enemy",
        param = "damage",
        value = -1,
        cost = 10,
        name = "damageDownEnemy",
    },

    healthDownEnemy =
    {
        entityType = "enemy",
        param = "health",
        value = -5,
        cost = 10,
        name = "healthDownEnemy",
    },

    dnaUpEnemy =
    {
        entityType = "enemy",
        param = "dna",
        value = 5,
        cost = 10,
        name = "dnaUpEnemy",
    },
}

function UpgradeStatics.apply(upgradeStatics, forExisting, entity)
    if state.dna >= upgradeStatics.cost then
        state.dna = state.dna - upgradeStatics.cost

        if entity then
            entity[upgradeStatics.param] = entity[upgradeStatics.param] + upgradeStatics.value
        else
            state.entityStatics[upgradeStatics.entityType][upgradeStatics.param] = state.entityStatics[upgradeStatics.entityType][upgradeStatics.param] + upgradeStatics.value

            if forExisting then
                local entities = state.entityManager:findAllEntities(
                    function(entity)
                        return entity.type == upgradeStatics.entityType
                    end
                    )

                for _, entityL in ipairs(entities) do
                    entityL[upgradeStatics.param] = entityL[upgradeStatics.param] + upgradeStatics.value
                end
            end
        end
    end
end

return UpgradeStatics