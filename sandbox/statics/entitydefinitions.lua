-- EntityStatic Definitions for SKoA-Sandbox:


local EStats = {

	FirstEncounter = {
		BattlefieldComponent = {
			units = {
				{
					unitId = "Wolf",
					pos = {60, 100},
				},
				{
					unitId = "Wolf",
					pos = {60, 200},
				},
				{
					unitId = "Knight",
					pos = {1000, 100},
				},
				{
					unitId = "Archer",
					pos = {1000, 200},
				},
				{
					unitId = "Priest",
					pos = {1000, 300},
				},
				{
					unitId = "Mage",
					pos = {1000, 400},
				},
			}
		}
	},

    Knight = {
    	UnitComponent = {
    		health = 90,
    		damage = 20,
            attackRange = 90,
    		defense = 10,
    		walkSpeed = 120,
            initiative = 8,
    	},
        SimpleIconComponent = {
            iconPath = "/sandbox/resources/unit_pictures/co_armygroup_axeman_circle.png",
            width = 64,
            height = 64,
        },
        CollisionComponent = {
            width = 64,
            height = 64,
        },
    },

    Priest = {
    	UnitComponent = {
    		health = 60,
    		damage = 20,
            attackRange = 90,
    		defense = 5,
    		walkSpeed = 120,
            initiative = 3,
    	},
        SimpleIconComponent = {
            iconPath = "/sandbox/resources/unit_pictures/co_armygroup_viking_outcast_circle.png",
            width = 64,
            height = 64,
        },
        CollisionComponent = {
            width = 64,
            height = 64,
        },
    },

    Archer = {
    	UnitComponent = {
    		health = 45,
    		damage = 30,
            attackRange = 330,
    		defense = 5,
    		walkSpeed = 180,
            initiative = 6,
    	},
        SimpleIconComponent = {
            iconPath = "/sandbox/resources/unit_pictures/co_armygroup_bowman_circle.png",
            width = 64,
            height = 64,
        },
        CollisionComponent = {
            width = 64,
            height = 64,
        },
    },

    Mage = {
    	UnitComponent = {
    		health = 30,
    		damage = 25,
            attackRange = 210,
    		defense = 0,
    		walkSpeed = 120,
            initiative = 4,
    	},
        SimpleIconComponent = {
            iconPath = "/sandbox/resources/unit_pictures/co_armygroup_brother_circle.png",
            width = 64,
            height = 64,
        },
        CollisionComponent = {
            width = 64,
            height = 64,
        },
    },

    Wolf = {
    	UnitComponent = {
    		health = 50,
    		damage = 10,
            attackRange = 90,
    		defense = 5,
    		walkSpeed = 240,
            initiative = 7,
    	},
        SimpleIconComponent = {
            iconPath = "/sandbox/resources/unit_pictures/co_armygroup_tamed_wolf_circle.png",
            width = 64,
            height = 64,
        },
        CollisionComponent = {
            width = 64,
            height = 64,
        },
    },
}

-- Set name to key.
for name, data in pairs(EStats) do
    if data.UnitComponent then
        data.UnitComponent.name = name
    end
end

return EStats

