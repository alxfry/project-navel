-- Static Settings

local EntityStatics = 
{
    master = 
    {
        health = 100,
        damage = 1,
        speed = 200,
        spriteSize = 20,
    },

    minion = 
    {
        health = 10,
        damage = 1,
        speed = 250,
        cost = 1,
        attackRange = 300,
    },

    enemy = 
    {
        health = 100,
        damage = 1,
        speed = 100,
        dna = 10,
    },

    building = 
    {
        health = 1000,
        radius = 40,
        dna = 100,
    },
}

return EntityStatics