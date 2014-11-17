local Class = require "smee.libs.middleclass"

local sti = require "smee.libs.sti"
local blocking = require "smee.logic.blocking"

local MapLoader = Class "MapLoader"

function MapLoader:initialize(mapName)
    local map = sti.new("maps/" .. mapName)
    blocking.setMap(map)

    -- local objects
    -- for k, v in pairs(map.tilesets) do
    --     if v.name == "objects" then
    --         objects = v.tiles
    --         break
    --     end
    -- end
    local objects = {}
    for k, v in pairs(map.layers.Objects.objects) do
        local tile = map.tiles[v.gid]
        -- TODO: TILE SHOULD BE ENTITY STATIC
        table.insert(objects, { 
            id = tile, 
            x = v.x + tile.width/2, 
            y = v.y - tile.height/2 })
    end

    self.objects = objects
    self.map = map
end

return MapLoader
