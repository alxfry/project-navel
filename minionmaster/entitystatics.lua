-- Static Settings

local EntityStatics = {
    master = {
        type = "master",
        health = 100,
        damage = 1,
        speed = 200,
    },

    minion = {
        type = "minion",
        health = 10,
        damage = 10,
        speed = 210,
        cost = 1,
        attackRange = 300,
    },

    enemy = {
        type = "enemy",
        health = 50,
        damage = 10,
        speed = 100,
        dna = 20,
        attackRange = 250,
    },

    weakenemy = {
        type = "enemy",
        health = 10,
        damage = 3,
        speed = 90,
        dna = 5,
        attackRange = 250,
        scale = 0.6,
    },

    building = {
        health = 1000,
        dna = 100,
    },
}

return EntityStatics
