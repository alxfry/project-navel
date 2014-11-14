local baseWidth, baseHeight = 1920, 1080
local mouseCursor
local fullscreen = false
local Entity = require "shared.entity"
local EntityManager = require "shared.entitymanager"

local entityManager

local function load()
    -- mouseCursor = love.graphics.newImage("images/ui/mouseCursor.png")
    love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })
	entityManager = EntityManager:new()
    local myUnit = Entity:new(0,0)
    entityManager:add(myUnit)
end

function love.update(dt)
	entityManager:update(dt)
end

function love.draw(dt)
    entityManager:update(dt)
    -- myUnit:draw(dt)
end

function love.keypressed(key, unicode)
	if key == "escape" then
        -- sends quit event
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.focus(focussed)
end

function love.textinput(text)
end

function love.resize(w, h)
end

return load
