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
	decayInterval = 0.8,
	decayAmount = 1,
    selectable = false,
}

EntityStatics.spawnPortal = {
	classSource = "hymn.spawnportal",
	health = 25,
	spawnEntityStatics = EntityStatics.basicDecayMinion,
    selectable = true,
}

EntityStatics.deposit = {
	classSource = "hymn.depost",
	health = 100,
    selectable = false,
}

return EntityStatics