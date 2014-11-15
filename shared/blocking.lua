local blocking = {
    map = false,
}

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

return blocking
