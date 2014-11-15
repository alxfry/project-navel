require "libs.cupid"

-- lock down the globals table for performance and error detection
setmetatable(_G, {
  __index = function(_, key)
    return error("no such global '" .. tostring(key) .. "'")
  end,
  __newindex = function(_, key, value)
    return error("creating global '" .. tostring(key) .. "' not allowed")
  end,
})

local sti           = require "libs.sti"

local state         = require "minionmaster.state"

local Enemy         = require "minionmaster.enemy"
local Minion        = require "minionmaster.minion"
local MinionMaster  = require "minionmaster.minionmaster"

local baseWidth, baseHeight = 1920, 1080
local mouseCursor

local enemyCount = 10

local zoom = 1
local zoomSpeed = 0.1

local function enemyDied(enemy)
    state.entityManager:remove(enemy.id)
end

local function load()
    mouseCursor = love.graphics.newImage("images/ui/mouseCursor.png")
    state.initialize()

    -- spawn the master
    state.master = MinionMaster:new()
    state.master:setPosition(baseWidth/4, baseHeight/4)
    state.entityManager:add(state.master)

    -- spawn initial enemies
    for i=1,enemyCount do
        local enemy = Enemy:new(state.master, enemyDied)
        enemy:setPosition(math.random(baseWidth/2),math.random(baseHeight/2))
        state.entityManager:add(enemy)
    end
end

function love.update(dt)
    state.entityManager:update(dt)
end

function love.draw(dt)
    state.entityManager:draw(dt)

    local translateX = love.mouse.getX()
    local translateY = love.mouse.getY()
    -- print(translateX, translateY)
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.translate(translateX, translateY)

    state.map:setDrawRange(translateX, translateY, width, height)
    -- map:draw(zoom,zoom)

    love.graphics.translate(0, 0)
end

function love.keypressed(key, unicode)
	if key == "escape" then
        -- sends quit event
        love.event.quit()
    end

    if key == "m" then
        local minion = Minion:new(state.master)
        minion:setPosition(state.master.position.x, state.master.position.y)
        state.entityManager:add(minion)
    end
end

function love.mousepressed(x, y, button)
    if button == "wd" then
        zoom = zoom - zoomSpeed
    elseif button == "wu" then
        zoom = zoom + zoomSpeed
    end
end

function love.mousereleased(x, y, button)
    -- screen.mousereleased(x,y, button)
end

function love.focus(focussed)
end

function love.textinput(text)
    -- GUI.textinput(text)
end

function love.resize(w, h)
    -- GUI.resize(w, h)
end

return load
