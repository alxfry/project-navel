local EntityStatics = {}

-- health 			-> int
-- speed  			-> pixel/second
-- decayInterval	-> second
-- decayAmount 		-> health

EntityStatics.basicDecayMinion = {
	classSource = "hymn.decayingunit",
	health = 10,
	stopRange = 10,
	speed = 300,
	decayInterval = 40,--0.3,
	decayAmount = 1,
    selectable = false,
}

EntityStatics.spawnPortal = {
	classSource = "hymn.spawnportal",
	health = 25,
	spawnEntityStatics = EntityStatics.basicDecayMinion,
    selectable = true,
    blockingShape = "circle",
    radius = 126/2,
}

EntityStatics.deposit = {
	classSource = "hymn.deposit",
	health = 100,
    selectable = false,
    blocking = true,
    blockingShape = "quad",
    baseWidth = 64,
    baseHeight = 64,
    radius = 32--(only for testing)
}

return EntityStatics