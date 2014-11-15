local Grid = require "libs.jumper.grid"
local Pathfinder = require "libs.jumper.pathfinder"

local floor = math.floor

local WALKABLE = 0
local BLOCKED = 1

local blocking = {
    map = false,
    grid = false,
}

function blocking.setMap(map)
    assert(type(map) == "table", "a map please")

    if blocking.map == map then
        return
    end

    blocking.map = map
    blocking.grid = false

    blocking.cellwidth = map.tilewidth / 2
    blocking.cellheight = map.tileheight / 2

    blocking.createFinder()
end

function blocking.toGrid(x, y)
    return floor(x / blocking.cellwidth) + 1,
           floor(y / blocking.cellheight) + 1
end

local function contains(map, x, y)
    return x >= 1 and y >= 1 and x <= map.width * 2 and y <= map.height * 2
end

function blocking.gridCollides(gridX, gridY)
    local map = assert(blocking.map, "no map specified")

    if not contains(map, gridX, gridY) then
        return true
    end

    return blocking.grid[gridY][gridX] == BLOCKED
end

function blocking.collides(x, y)
    return blocking.gridCollides(blocking.toGrid(x,  y))
end

local function raytrace(x0, y0, x1, y1, visit)
    local dx = math.abs(x1 - x0)
    local dy = math.abs(y1 - y0)

    local x = floor(x0)
    local y = floor(y0)

    local n = 1
    local x_inc, y_inc
    local err

    if dx == 0 then
        x_inc = 0
        err = math.huge
    elseif x1 > x0 then
        x_inc = 1
        n = n + (floor(x1) - x)
        err = (floor(x0) + 1 - x0) * dy
    else
        x_inc = -1
        n = n + (x - floor(x1))
        err = (x0 - floor(x0)) * dy
    end

    if dy == 0 then
        y_inc = 0
        err = err - math.huge
    elseif y1 > y0 then
        y_inc = 1
        n = n + (floor(y1) - y)
        err = err - (floor(y0) + 1 - y0) * dx
    else
        y_inc = -1
        n = n + (y - floor(y1))
        err = err - (y0 - floor(y0)) * dx;
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
    return raytrace(x0, y0, x1, y1, blocking.gridCollides)
end

local function getPath(startX, startY, endX, endY, clearance)
    local map = assert(blocking.map, "no map specified")
    local startGridX, startGridY = blocking.toGrid(startX, startY)
    local endGridX, endGridY = blocking.toGrid(endX, endY)

    -- Can't find paths when either of the locations is invalid
    if not contains(map, startGridX, startGridY) or
       not contains(map, endGridX, endGridY) then
        return
    end

    return blocking.finder:getPath(startGridX, startGridY, endGridX, endGridY, clearance)
end

function blocking.pathExists(startX, startY, endX, endY)
    return getPath(startX, startY, endX, endY) and true or false
end

function blocking.findPath(startX, startY, endX, endY)
    local path = getPath(startX, startY, endX, endY)
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

    local map = blocking.map
    local waypoints = {}
    local lastRequiredGridX, lastRequiredGridY
    local previousGridX, previousGridY

    for node, count in path:nodes() do
        if count > 1 then
            local gridX, gridY = node:getX(), node:getY()

            if previousGridX then
                if lineOfSight(lastRequiredGridX, lastRequiredGridY, gridX, gridY) then
                    previousGridX, previousGridY = gridX, gridY
                else
                    local x = (previousGridX-1) * (blocking.cellwidth)
                    local y = (previousGridY-1) * (blocking.cellheight)
                    x = x + map.tilewidth / 4
                    y = y + map.tileheight / 4
                    waypoints[#waypoints + 1] = { x = x, y = y }
                    lastRequiredGridX, lastRequiredGridY = previousGridX, previousGridY
                end
            else
                lastRequiredGridX, lastRequiredGridY = gridX, gridY
            end

            previousGridX, previousGridY = gridX, gridY
        end
    end

    waypoints[#waypoints + 1] = { x = endX, y = endY }

    return waypoints
end

function blocking.createFinder()
    local map = assert(blocking.map, "no map specified")

    -- Generate grid and finder instances on-demand
    local groundLayer = map.layers[1]
    local grid = {}

    for y = 1, map.height do
        local row1 = {}
        local row2 = {}

        for x = 1, map.width do
            local topLeft, topRight, bottomLeft, bottomRight = WALKABLE, WALKABLE, WALKABLE, WALKABLE
            local tile = groundLayer.data[y][x]

            local terrain = tile.terrain
            if terrain then
                local topLeftTerrain = terrain[1]
                local topRightTerrain = terrain[2]
                local bottomLeftTerrain = terrain[3]
                local bottomRightTerrain = terrain[4]

                topLeft = topLeftTerrain.properties.block and BLOCKED or WALKABLE
                topRight = topRightTerrain.properties.block and BLOCKED or WALKABLE
                bottomLeft = bottomLeftTerrain.properties.block and BLOCKED or WALKABLE
                bottomRight = bottomRightTerrain.properties.block and BLOCKED or WALKABLE
            end

            row1[x*2-1] = topLeft
            row1[x*2] = topRight
            row2[x*2-1] = bottomLeft
            row2[x*2] = bottomRight
        end

        grid[y*2-1] = row1
        grid[y*2] = row2
    end

    --[[
    print("{")
    for y,row in ipairs(grid) do
        print("   {",table.concat(row, ","),"}")
    end
    print("}")
    --]]

    blocking.grid = grid
    blocking.finder = Pathfinder(Grid(grid), 'JPS', WALKABLE)
end

--[[
function blocking.updateDynamicBlock(oldX, oldY, x, y)
    local previousGridX, previousGridY = blocking.toGrid(oldX, oldY)
    local newGridX, newGridY = blocking.toGrid(x, y)

    print(newGridX, newGridY)
    local grid = blocking.grid

    if previousGridX ~= newGridX or previousGridY ~= newGridY then
        grid[previousGridY][previousGridX] = grid[previousGridY][previousGridX] - 1
        grid[newGridY][newGridX] = grid[newGridY][newGridX] + 1
    end
end

function blocking.addDynamicBlock(x, y)
    local gridX, gridY = blocking.toGrid(x, y)
    local grid = blocking.grid
    grid[gridY][gridX] = grid[gridY][gridX] + 1
end

function blocking.removeDynamicBlock(x, y)
    local gridX, gridY = blocking.toGrid(x, y)
    local grid = blocking.grid
    grid[gridY][gridX] = grid[gridY][gridX] - 1
end
--]]

return blocking
