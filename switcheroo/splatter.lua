
local lg = love.graphics

local Flext = require "flext"

local instances = {}

local splatterImages = {
    lg.newImage("images/player/playerSplat01.png"),
    lg.newImage("images/player/playerSplat02.png"),
    lg.newImage("images/player/playerSplat03.png"),
    lg.newImage("images/player/playerSplat04.png"),
}

local playerInfo = {
    {
        name = "Green",
        r = 0, g = 255, b = 0,
    },
    {
        name = "Red",
        r = 255, g = 0, b = 0,
    },
    {
        name = "Yellow",
        r = 255, g = 255, b = 0,
    },
    {
        name = "Blue",
        r = 0, g = 0, b = 255,
    },
}

local function create(x, y, killer, victim, weapon)
    local vInfo = playerInfo[victim.colorIndex]
    local kInfo = playerInfo[killer.colorIndex]
    local s =
    {
        pos = {x = x, y = y},
        image = splatterImages[math.random(4)],
        r = vInfo.r, g = vInfo.g, b = vInfo.b,
        age = 0,
    }
        
    if victim.stats.lives == 0 then
        if killer == victim then
            s.duration = 60
            s.scale = 0.3
            s.flext = Flext.create(s.pos, vInfo.name.." is suicidal!", 20, 120)
        elseif victim.stats.isKing then
            s.duration = 75
            s.scale = 0.4
            s.flext = Flext.create(s.pos, kInfo.name.." killed the king!", 20, 120)
        else
            s.duration = 60
            s.scale = 0.3
            s.flext = Flext.create(s.pos, "R.I.P."..vInfo.name.."...", 20, 120)
        end
    else
        s.duration = 45
        s.scale = 0.2
    end
    
    instances[s] = true
    return s
end

local function update(dt)
    for s in pairs(instances) do
        s.age = s.age + dt
        if s.age >= s.duration then instances[s] = nil end
    end
end

local function draw()
    for s in pairs(instances) do
        local fade = 1 - s.age/s.duration
        lg.setColor(s.r,s.g,s.b,fade*192)
        lg.draw(s.image, s.pos.x, s.pos.y, 0, s.scale, s.scale, s.image:getWidth()/2, s.image:getHeight()*0.8)
    end
end

return {
    create = create,
    update = update,
    draw = draw,
}