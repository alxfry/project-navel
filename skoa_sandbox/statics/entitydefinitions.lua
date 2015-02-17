-- EntityStatic Definitions for SKoA-Sandbox:


local EStats = {

	FirstEncounter = {
		BattlefieldComponent = {
			units = {
				{
					unitId = "Wolf",
					pos = {10, 100},
				},
				{
					unitId = "Wolf",
					pos = {10, 200},
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
    		damage = 40,
    		defense = 15,
    		walkSpeed = 10,
    	},
        SimpleIconComponent = {
            iconPath = "/skoa_sandbox/resources/unit_pictures/co_armygroup_axeman_circle.png",
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
    		damage = 40,
    		defense = 5,
    		walkSpeed = 10,
    	},
        SimpleIconComponent = {
            iconPath = "/skoa_sandbox/resources/unit_pictures/co_armygroup_viking_outcast_circle.png",
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
    		damage = 60,
    		defense = 5,
    		walkSpeed = 10,
    	},
        SimpleIconComponent = {
            iconPath = "/skoa_sandbox/resources/unit_pictures/co_armygroup_bowman_circle.png",
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
    		damage = 50,
    		defense = 0,
    		walkSpeed = 10,
    	},
        SimpleIconComponent = {
            iconPath = "/skoa_sandbox/resources/unit_pictures/co_armygroup_brother_circle.png",
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
    		health = 30,
    		damage = 20,
    		defense = 10,
    		walkSpeed = 10,
    	},
        SimpleIconComponent = {
            iconPath = "/skoa_sandbox/resources/unit_pictures/co_armygroup_tamed_wolf_circle.png",
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

