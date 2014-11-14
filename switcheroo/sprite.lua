
local lg = love.graphics

local db = {}

local instances = {}

local head

local function load()
    --local dir = love.filesystem.getWorkingDirectory().."/sprites"
    local dir = ""
    print("scanning sprites...["..dir.."]")
    local files = love.filesystem.getDirectoryItems(dir)
    
    for i,f in ipairs(files) do
        if string.sub(f,-4) == ".png" then
            if string.len(f) == 13 then
                local name = string.sub(f,1,3)
                local set = string.sub(f,5,7)
                local index = tonumber(string.sub(f,9,9))
                print("ani sprite: "..name.."/"..set.."/"..index)
                if not db[name] then db[name] = {} end
                local sprite = db[name]
                if not sprite[set] then sprite[set] = {} end
                local set = sprite[set]
                set[index] = lg.newImage(f)
                if not set[index] then print("AAAAAHAHH") end
            else
                local name = string.sub(f,1,-5)
                --local name = f
                --print("static sprite: "..name)
            end
        end
    end
end

local function create(basename, center)
    speed = speed or 0
    scale = scale or 1
    local res = db[basename]
    local kit,frames = next(res)
    local s = {
        x = 0, y = 0,
        speed = speed,
        scale = scale,
        rot = 0,
        kit = kit,
        _res = res,
        _nextframe = speed,
        _frameindex = 1,
        _image = frames[1],
        _center = center,
        _next = next(instances),
        dx = 0,
        dy = 0,
        alpha = 255,
    }
    if center == "feet" then
        s._ox = s._image:getWidth()/2
        s._oy = s._image:getHeight()*0.75
        s.dy = 0
    elseif center == "head" then
        s._ox = s._image:getWidth()*0.5
        s._oy = s._image:getHeight()*(0.1)
        --s.dx = -s._image:getWidth()*0.1
        s.dy = -s._image:getHeight()*(0.9)
        s.dy = -275
    else
        s._ox = s._image:getWidth()*0.5
        s._oy = s._image:getHeight()*(0.5+0.16)
        --s.dx = -s._image:getWidth()*0.1
        s.dy = -s._image:getHeight()*(0.25-0.16)
    end
    instances[s] = true
    return s
end

local function destroy(s)
    s.x = "BROKEN"
    instances[s] = nil
end

local function update(dt)
    head = nil
    for s in pairs(instances) do
        s._nextframe = s._nextframe - dt
        if s._nextframe <= 0 then
            s._nextframe = s.speed
            s._frameindex = s._frameindex+1
            if s._frameindex > #s._res[s.kit] then s._frameindex = 1 end
            s._image = s._res[s.kit][s._frameindex]
            --[[
            if s._center == "feet" then
                s._ox = s._image:getWidth()/2
                s._oy = s._image:getHeight()
                s.dy = 0
            else
                s._ox = s._image:getWidth()/2
                s._oy = s._image:getHeight()/2
                s.dy = -s._image:getHeight()/3
            end
            --]]
        end
        if head and head.y < s.y then
            local i = head
            while i._next and i._next.y < s.y do
                i = i._next
            end
            s._next = i._next
            i._next = s
        else
            s._next = head
            head = s
        end
    end
end

function draw()
    local s = head
    while s do
        lg.setColor(255,255,255,s.alpha)
        lg.draw(s._image, s.x+s.dx*s.scale, s.y+s.dy*s.scale, s.rot, s.flip and -s.scale or s.scale, s.scale, s._ox, s._oy)
        s = s._next
    end
end

return {
    load = load,
    create = create,
    destroy = destroy,
    update = update,
    draw = draw,
}