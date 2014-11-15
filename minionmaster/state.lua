-- Central access point for game state

local sti           = require "libs.sti"

local blocking      = require "shared.blocking"
local EntityManager = require "shared.entitymanager"

local baseWidth, baseHeight = 1920, 1080

local state = {}

function state.initialize()
	state.entityManager = EntityManager:new()

    state.dna = 100

    -- load the map
    state.map = sti.new("testmap")
    blocking.map = state.map
end

return state
