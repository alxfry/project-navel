
local lg = love.graphics

local instances = {}

local function create(pos_ref, text, height1, height2, playerColor)
    local t =
    {
        text = text,
        expire = 2,
        pos_ref = pos_ref,
        height1 = height1,
        height2 = height2,
        height = height1,
        playerColor = playerColor
    }
    instances[t] = true
    return t
end

local function update(dt)
    for t in pairs(instances) do
        t.expire = t.expire - dt
        if t.expire < 1 then
            t.height = t.height2
        else
            t.height = t.height1 + (t.height2-t.height1)*(2-t.expire)
        end
        if t.expire <= 0 then instances[t] = nil end
    end
end

local function draw()
    love.graphics.setFont(FontMidSize)
    
    for t in pairs(instances) do
        --print("flext: "..t.text.."("..t.pos_ref.x.."/"..t.pos_ref.y..")")
        --lg.printf(t.text, t.pos_ref.x, t.pos_ref.y-t.height, 300, "center")
        
        local color = t.playerColor or {0, 0, 0, 255}
        lg.setColor(unpack(color))
        lg.print(t.text, t.pos_ref.x-60, t.pos_ref.y-t.height - 30, 0)
        --lg.printf(t.text, t.pos_ref.x, t.pos_ref.y-t.height, 500, "center")
    end
end

return {
    create = create,
    update = update,
    draw = draw,
}