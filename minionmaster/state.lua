-- Central access point for game state

local sti           = require "libs.sti"

local blocking      = require "shared.blocking"
local EntityManager = require "shared.entitymanager"
local Player = require "shared.player"

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
    state.map = sti.new("testmap")
    blocking.setMap(state.map)
end

return state
