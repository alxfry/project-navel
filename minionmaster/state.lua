-- Central access point for game state

local sti           = require "spiceminion_engine.libs.sti"

local blocking      = require "spiceminion_engine.logic.blocking"
local EntityManager = require "spiceminion_engine.game_core.entitymanager"
local Player 		= require "spiceminion_engine.game_core.player"

local EntityStatics = require "minionmaster.entitystatics"

local baseWidth, baseHeight = 1920, 1080

local state = {}

function state.initialize()
	state.entityManager = EntityManager:new()
    state.player = Player:new()
    state.entityStatics = EntityStatics

    state.dna = 100
    state.status = "playing"

    -- load the map
    state.map = sti.new("maps/hauntedislands")
    state.map.layers.objects.draw = function() end
    blocking.setMap(state.map)
end

return state
