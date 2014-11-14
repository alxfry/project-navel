local Level = require "level"
local Sound = require "sound"

local lg = love.graphics

local grenades = {}
local fragments = {}

local function create(x, y, dx, dy, props, owner)
    if props.createSound then Sound.play(props.createSound) end
    if props.expiry then
        local g = {x=x+dx*0.1, y=y+dy*0.1, dx=dx, dy=dy, expire=props.expiry, props = props, owner = owner}
        grenades[g] = true
    else
        local f = {
            x=x+dx*0.05,y=y+dy*0.05,
            dx=dx,dy=dy,
            expire=props.fragmentExpiry,
            rot=math.atan2(dy,dx),
            props = props,
            owner = owner,
        }
        fragments[f] = true
    end
end

local function move(o, dt)
    local target, hit = Level.trace(o.x, o.y, o.x + o.dx*dt, o.y + o.dy*dt)
    o.x = target.x
    o.y = target.y
    o.expire = o.expire - dt
    if hit then
        return false
    elseif o.expire <= 0 then
        return false
    else
        return true
    end
end

local function update(dt)
    for g in pairs(grenades) do
        if not move(g, dt) then
            grenades[g] = nil
            if g.props.explodeSound then Sound.play(g.props.explodeSound) end
            for i=0,359,10 do
                local f = {
                    x=g.x,y=g.y,
                    dx=math.sin(math.deg(i))*500,dy=math.cos(math.deg(i))*500,
                    expire=g.props.fragmentExpiry,
                    rot=i,
                    props = g.props,
                    owner = g.owner
                }
                fragments[f] = true
            end
            --
        end
    end
    for f in pairs(fragments) do
        if not move(f, dt) then
            fragments[f] = nil
        end
    end
end

local function draw()
    lg.setColor(255,255,255)
    for g in pairs(grenades) do
        local img = g.props.projectileImage
        lg.draw(img, g.x, g.y, 0, g.props.projectileImageScale, g.props.projectileImageScale, img:getWidth()/2, img:getHeight()/2)
    end
    for f in pairs(fragments) do
        img = f.props.fragmentImage
        lg.draw(img, f.x, f.y, f.rot, 0.2, 0.2, img:getWidth()/2, img:getHeight()/2)
    end
end

local function collide(cx, cy, rad, last)
    rad = rad*rad
    local f = next(fragments, last)
    while f do
        if f.expire > 0 then
            local dx, dy = f.x-cx, f.y-cy
            local dist = dx*dx+dy*dy
            if dist < rad then break end
        end
        f = next(fragments, f)
    end
    return f
end

return {
    load = load,
    create = create,
    update = update,
    draw = draw,
    collide = collide,
    destroy = destroy,
}