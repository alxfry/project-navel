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

local function contains(map, x, y)
    return x >= 1 and y >= 1 and x <= map.width and y <= map.height
end

function blocking.tileCollides(tileX, tileY)
    local map = assert(blocking.map, "no map specified")

    tileX = math.floor(tileX)
    tileY = math.floor(tileY)

    if not contains(map, tileX, tileY) then
        return true
    end

    local groundLayer = map.layers[1]
    local tile = groundLayer.data[tileY+1][tileX+1]
    local properties = tile and tile.properties

    return (properties and properties.block) or false
end

function blocking.collides(x, y)
    local map = assert(blocking.map, "no map specified")

    local mapWidth = map.tilewidth * map.width
    local mapHeight = map.tileheight * map.height

    -- First do a simple out of bounds check
    if x < 0 or y < 0 or x > mapWidth or y > mapHeight then
        return true
    end

    return blocking.tileCollides(map:convertScreenToTile(x, y))
end

local function trace(x, y, x2, y2)
    local w = x2 - x
    local h = y2 - y
    local dx1, dy1, dx2, dy2 = 0, 0, 0, 0
    if w < 0 then dx1 = -1 elseif w > 0 then dx1 = 1 end
    if h < 0 then dy1 = -1 elseif h > 0 then dy1 = 1 end
    if w < 0 then dx2 = -1 elseif w > 0 then dx2 = 1 end
    local longest = math.abs(w)
    local shortest = math.abs(h)
    if not (longest > shortest) then
        longest = math.abs(h)
        shortest = math.abs(w)
        if (h < 0) then dy2 = -1 elseif h > 0 then dy2 = 1 end
        dx2 = 0
    end
    local numerator = math.floor(longest/2)
    local lx, ly = x, y
    for i = 0, longest do
        if blocking.tileCollides(x,y) then
            return lx, ly, true
        end
        lx, ly = x, y
        numerator = numerator + shortest
        if not (numerator < longest) then
            numerator = numerator - longest
            x = x + dx1
            y = y + dy1
        else
            x = x + dx2
            y = y + dy2
        end
    end
    return x2, y2, false
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
    if not path then
        return
    end

    if #path._nodes > 1 then
        path:fill()
    end

    --[[
    print(('Path found! Length: %.2f'):format(path:getLength()))
    for node, count in path:nodes() do
        print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
    end
    --]]

    local waypoints = {}
    local lastRequiredTileX, lastRequiredTileY
    local previousTileX, previousTileY

    for node, count in path:nodes() do
        if count > 1 then
            local tileX, tileY = node:getX(), node:getY()

            if previousTileX then
                -- local hitX, hitY, hit = trace(lastRequiredTileX, lastRequiredTileY, tileX, tileY)
                -- if not hit then
                --     previousTileX, previousTileY = tileX, tileY
                -- else
                    local x, y = map:convertTileToScreen(previousTileX-1, previousTileY-1)
                    x = x + map.tilewidth / 2
                    y = y + map.tileheight / 2
                    waypoints[#waypoints + 1] = { x = x, y = y }
                    lastRequiredTileX, lastRequiredTileY = previousTileX, previousTileY
                -- end
            else
                lastRequiredTileX, lastRequiredTileY = tileX, tileY
            end

            previousTileX, previousTileY = tileX, tileY
        end
    end

    waypoints[#waypoints + 1] = { x = endX, y = endY }

    return waypoints
end

return blocking
