local lg = love.graphics

local blocking = {}

function blocking.get(x, y)
    return blocking[x + y * blocking.w]
end

function blocking.set(x, y, value)
    blocking[x + y * blocking.w] = value
end

local background

local function load(map)
    map = map or "map04"
    
    --background = lg.newImage("images/bg/" .. map .. "#texture.png")
    background = lg.newImage("images/bg/" .. map .. "#texture.jpg")
    local block = lg.newImage("images/bg/" .. map .. "#blocking.png")
    
    local w, h = block:getDimensions()
    blocking.w = w
    blocking.h = h

    for x = 0, w-1 do
        for y = 0, h-1 do
            local r, g, b, a = block:getData():getPixel(x, y)
            blocking.set(x, y, r < 128 and g < 128 and b < 128)
        end
    end
end

local function draw()
    lg.draw(background, 0, 0, 0, 0.5, 0.5)
end

local function bresenham(x, y, x2, y2)
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
        if blocking.get(x,y) then
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

-- returns first hit from (x,y) to (x+dx, y+dy)
local function trace(sx, sy, ex, ey)
    sx = math.floor(sx + 0.5)
    sy = math.floor(sy + 0.5)
    ex = math.floor(ex + 0.5)
    ey = math.floor(ey + 0.5)
    local x, y, hit = bresenham(sx, sy, ex, ey)
    
    return { x = x, y = y }, hit
end

load()

return {
    draw = draw,
    trace = trace,
}
