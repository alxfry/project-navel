local flux          = require "smee.libs.flux"
local NavelGame     = require "navelgame"
-- DEBUG = true
local baseWidth, baseHeight = 1920, 1080

local _theGame

function love.load()
    love.window.setTitle("Project Navel")
    -- We want to use SMEE
    require "smee.smeeinit"
    -- love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })
    _theGame = NavelGame:new()

    _theGame:load()
    _theGame:init()
end

function love.update(dt)
    _theGame:update(dt)
    -- ??? flux.update(dt)aa
end


function love.draw(dt)
    _theGame:draw(dt)
end

function love.keypressed(key, unicode)
    -- local altPressed = love.keyboard.isDown('lalt') or love.keyboard.isDown('ralt')
    -- if key == "escape" then
    --     -- sends quit event
    --     love.event.quit()
    -- end
    -- if key == 'return' and altPressed then
    --    fullscreen = not fullscreen
    --    love.window.setFullscreen(fullscreen, "desktop")
    -- end

    _theGame.inputHandler:keyPressed(key, unicode)
end

function love.mousepressed(x, y, button)
    _theGame.inputHandler:mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
    _theGame.inputHandler:mouseReleased(x, y, button)
end

function love.focus(focused)
end

function love.textinput(text)
end

function love.resize(w, h)
    -- HymnGame.map:resize(w, h)
end

return load