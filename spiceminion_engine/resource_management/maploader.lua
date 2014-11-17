local Class = require "spiceminion_engine.libs.middleclass"

local sti = require "spiceminion_engine.libs.sti"
local blocking = require "spiceminion_engine.logic.blocking"

local MapLoader = Class "MapLoader"

function MapLoader:initialize(mapName, spawnFunction)
    local map = sti.new("maps/" .. mapName)
    blocking.setMap(map)

    local objects
    for k, v in pairs(map.tilesets) do
        if v.name == "objects" then
            objects = v.tiles
            break
        end
    end

    for k, v in pairs(map.layers.Objects.objects) do
        local tile = map.tiles[v.gid]
        spawnFunction(tile, v.x + tile.width/2, v.y - tile.height/2)
    end

    self.map = map
end

return MapLoader
