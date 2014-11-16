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
	decayInterval = 40,
	decayAmount = 1,
    selectable = false,
}

EntityStatics.spawnPortal = {
	classSource = "hymn.spawnportal",
	health = 25,
	spawnEntityStatics = EntityStatics.basicDecayMinion,
    selectable = true,
    radius = 126/2,
}

EntityStatics.deposit = {
	classSource = "hymn.depost",
	health = 100,
    selectable = false,
    blocking = true,
    radius = 64/2,
}

return EntityStatics