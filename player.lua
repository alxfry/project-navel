local Sprite = require "sprite"
local Grenade = require "grenade"
local Level = require "level"
local Flext = require "flext"
local Sound = require "sound"
local Splatter = require "splatter"

local next_pid = 1
local nextCharacter = 1

local instances = {}

local spawnPoints =
{
    {x=200,y=200},
    {x=1920-200,y=200},
    {x=1920-200,y=1080-200},
    {x=200,y=1080-200},
}

local function load()
    nextCharacter = math.random(4)
end

local playerColors = {
    [1] = "grn", 
    [2] = "red",
    [3] = "yel",
    [4] = "blu",
}

local function colorById(idx)
    return playerColors[idx]
end

local function create(name, character)
    Sound.play("spawn")
    print("cp")
    local p = {
        name == name,
        pid = next_pid,
        pos = {x = 200, y = 200},
        speed = 200,
        sound = {},
        cooldown = 2,
    }
    instances[next_pid] = p
    next_pid = next_pid+1

    if character then
        p.character = character
    else
        p.character = nextCharacter % 4 + 1
        nextCharacter = nextCharacter+1
    end
    
    p.sprite = Sprite.create("cr" .. p.character, "feet")

    p.sprite.speed = 0.15
    p.sprite.scale = 0.3
    
    p.weapon = Sprite.create("wpc", "center")
    p.weapon.kit = "cr" .. p.character
    
    p.weapon.scale = 0.3
    
    p.shadow = Sprite.create("shd", "feet")
    p.shadow.scale = 0.3
    p.shadow.alpha = 192

    p.crown = Sprite.create("crw", "head")
    p.crown.scale = 0.35

    local sps = {}
    for i,sp in ipairs(spawnPoints) do
        if not sp.cooldown then sps[#sps+1] = sp end
    end
    local sp
    if #sps > 0 then sp = sps[math.random(#sps)]
    else sp = spawnPoints[math.random(#spawnPoints)] end
    
    p.pos.x = sp.x
    p.pos.y = sp.y
    sp.cooldown = 5
    
    return p
end

local function destroy(p)
    print("dp")
    Sprite.destroy(p.sprite)
    p.sprite = nil
    Sprite.destroy(p.weapon)
    p.weapon = nil
    Sprite.destroy(p.shadow)
    p.shadow = nil
    Sprite.destroy(p.crown)
    p.crown = nil
    instances[p.pid] = nil
end

local function update(dt)
    for i,sp in ipairs(spawnPoints) do
        if sp.cooldown then
            sp.cooldown = sp.cooldown-dt
            if sp.cooldown <= 0 then sp.cooldown = nil end
        end
    end
    for i,p in pairs(instances) do
        local pos = p.pos
        local input = p.controller:getData(pos.x, pos.y)
        local newX = pos.x + input.move.x*dt*p.speed
        local newY = pos.y + input.move.y*dt*p.speed
        local blocked = Level.trace(pos.x, pos.y, newX, newY)
        pos.x = blocked.x
        pos.y = blocked.y
        p.sprite.x = pos.x
        p.sprite.y = pos.y
        if input.move.x < 0 then
            p.sprite.flip = true
        elseif input.move.x > 0 then
            p.sprite.flip = false
        end
        p.weapon.x = pos.x
        p.weapon.y = pos.y+0.001
        local aimAngle = input.aim.angle
        if aimAngle < 0 then
            p.weapon.flip = true
            p.weapon.rot = aimAngle-math.rad(270)
        else
            p.weapon.flip = false
            p.weapon.rot = aimAngle-math.rad(90)
        end

        p.weapon.kit = colorById(p.controller.colorIndex)

        p.shadow.x = pos.x
        p.shadow.y = pos.y-0.001
        p.shadow.kit = "gry"

        p.crown.x = pos.x
        p.crown.y = pos.y+0.002
        p.crown.alpha = p.controller.stats.isKing and 225 or 0

        if p.cooldown then
            p.cooldown = p.cooldown - dt
            if p.cooldown <= 0 then p.cooldown = nil end
        end
        
        if math.abs(input.move.x) + math.abs(input.move.y) == 0 then
            p.sprite.kit = "idl"
            if p.sound.walk then
                p.sound.walk:stop()
                p.sound.walk = nil
            end
        else
            p.sprite.kit = "run"
            if not p.sound.walk then
                p.sound.walk = Sound.play("step")
            end
        end
        
        if p.flext and p.flext.expire <= 0 then p.flext = nil end
        
        if p.cooldown then
            p.cooldown = p.cooldown - dt
            local alpha
            if p.cooldown <= 0 then
                p.cooldown = nil
                alpha = 255
            else
                alpha = 255 - 128*p.cooldown
            end
            p.sprite.alpha = alpha
            p.weapon.alpha = alpha
        else
            local f = Grenade.collide(pos.x,pos.y-20,40)
            while f do
                f.expire = 0
                if p.flext then
                    p.flext.text = p.flext.text.."!"
                    p.ouch = p.ouch + 0.1
                    p.controller:vibrate(p.ouch, p.ouch)
                else
                    p.ouch = 0.4

                    local playerColors = {
                        [1] = {0, 255, 0, 255},
                        [2] = {255, 0, 0, 255},
                        [3] = {255, 255, 0, 255},
                        [4] = {0, 0, 255, 255},
                    }                    
                    local playerColor = playerColors[p.controller.colorIndex]
                    
                    p.flext = Flext.create(pos, "ouch!", 90, 110, playerColor)
                    p.controller:vibrate(p.ouch, p.ouch)
                end
                p.controller.stats.health = p.controller.stats.health-1
                if p.controller.stats.health == 0 then
                    if f.owner ~= p.controller then
                        f.owner.stats.kills = f.owner.stats.kills+1
                    end
                    Splatter.create(pos.x, pos.y, f.owner, p.controller, f.props.weapon)                    
                end
                f = Grenade.collide(pos.x,pos.y,20,f)
            end
        end
    end
end

local function get(pid)
    return instances[pid]
end

return {
    load = load,
    create = create,
    destroy = destroy,
    update = update,
    get = get
}