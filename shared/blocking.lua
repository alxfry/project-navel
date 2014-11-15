local Grid = require "libs.jumper.grid"
local Pathfinder = require "libs.jumper.pathfinder"

local WALKABLE = 0
local BLOCKED = 1

local blocking = {
    map = false,
    grid = false,
}

function blocking.setMap(map)
    if self.map == map then
        return
    end

    self.map = map
    self.grid = false
end

function blocking.collides(x, y)
    local map = assert(blocking.map, "no map specified")

    local mapWidth = map.tilewidth * map.width
    local mapHeight = map.tileheight * map.height

    -- First do a simple out of bounds check
    if x < 0 or y < 0 or x > mapWidth or y > mapHeight then
        return true
    end

    local tileX, tileY = map:convertScreenToTile(x, y)
    tileX = math.floor(tileX)
    tileY = math.floor(tileY)

    local groundLayer = map.layers[1]
    local tile = groundLayer.data[tileY+1][tileX+1]
    local properties = tile and tile.properties

    return (properties and properties.block) or false
end

local function contains(map, x, y)
    return x >= 1 and y >= 1 and x <= map.width and y <= map.height
end

function blocking.findPath(startX, startY, endX, endY)
    local map = assert(blocking.map, "no map specified")

    -- Generate grid and finder instances on-demand
    if not blocking.finder then
        local groundLayer = map.layers[1]
        local grid = {}

        for y = 1, map.height do
            local row = {}

            for x = 1, map.width do
                local tile = groundLayer.data[y][x]
                local properties = tile and tile.properties
                row[x] = (properties and properties.block and BLOCKED) or WALKABLE
            end

            grid[y] = row
        end

        blocking.finder = Pathfinder(Grid(grid), 'JPS', WALKABLE)
    end

    local startTileX, startTileY = map:convertScreenToTile(startX, startY)
    startTileX = math.floor(startTileX) + 1
    startTileY = math.floor(startTileY) + 1

    local endTileX, endTileY = map:convertScreenToTile(endX, endY)
    endTileX = math.floor(endTileX) + 1
    endTileY = math.floor(endTileY) + 1

    -- Can't find paths when either of the locations is invalid
    if not contains(map, startTileX, startTileY) or
       not contains(map, endTileX, endTileY) then
        return
    end

    local path = blocking.finder:getPath(startTileX, startTileY, endTileX, endTileY)

    --[[
    if path then
        print(('Path found! Length: %.2f'):format(path:getLength()))
        for node, count in path:nodes() do
            print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
        end
    else
        print("No path found")
    end
    --]]

    return path
end

return blocking
