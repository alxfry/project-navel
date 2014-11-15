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

local function raytrace(x0, y0, x1, y1, visit)
    local dx = math.abs(x1 - x0)
    local dy = math.abs(y1 - y0)

    local x = math.floor(x0)
    local y = math.floor(y0)

    local n = 1
    local x_inc, y_inc
    local err

    if dx == 0 then
        x_inc = 0
        err = math.huge
    elseif x1 > x0 then
        x_inc = 1
        n = n + (math.floor(x1) - x)
        err = (math.floor(x0) + 1 - x0) * dy
    else
        x_inc = -1
        n = n + (x - math.floor(x1))
        err = (x0 - math.floor(x0)) * dy
    end

    if dy == 0 then
        y_inc = 0
        err = err - math.huge
    elseif y1 > y0 then
        y_inc = 1
        n = n + (math.floor(y1) - y)
        err = err - (math.floor(y0) + 1 - y0) * dx
    else
        y_inc = -1
        n = n + (y - math.floor(y1))
        err = err - (y0 - math.floor(y0)) * dx;
    end

    for i = n, 1, -1 do
        if visit(x, y) then
            return false
        end

        if err > 0 then
            y = y + y_inc
            err = err - dx
        else
            x = x + x_inc
            err = err + dy
        end
    end

    return true
end

local function lineOfSight(x0, y0, x1, y1)
    return raytrace(x0, y0, x1, y1, blocking.tileCollides)
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
                if lineOfSight(lastRequiredTileX, lastRequiredTileY, tileX, tileY) then
                    previousTileX, previousTileY = tileX, tileY
                else
                    local x, y = map:convertTileToScreen(previousTileX-1, previousTileY-1)
                    x = x + map.tilewidth / 2
                    y = y + map.tileheight / 2
                    waypoints[#waypoints + 1] = { x = x, y = y }
                    lastRequiredTileX, lastRequiredTileY = previousTileX, previousTileY
                end
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
