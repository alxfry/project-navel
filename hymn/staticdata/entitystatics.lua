local EntityStatics = {}

-- health 			-> int
-- speed  			-> pixel/second
-- decayInterval	-> second
-- decayAmount 		-> health

EntityStatics.basicDecayMinion = {
	health = 10,
	speed = 300,
	decayInterval = 1,
	decayAmount = 1,
    selectable = false,
}

EntityStatics.spawnPortal = {
	health = 25,
    selectable = true,
}

return EntityStatics