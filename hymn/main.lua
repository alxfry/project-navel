local flux          = require "smee.libs.flux"
DEBUG = true
local HymnGame      = require "hymn.logiccore"

local baseWidth, baseHeight = 1920, 1080

-- TODO Create UI Component
local ui = require "hymn.ui"

local function load()
    love.window.setTitle("Hymn of Snow and Lava")
    love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })

    HymnGame:load("testmap")
    HymnGame:init()

    -- pan to own base
    for id, entity in pairs(HymnGame.entityManager.entities) do
        if entity.selectable and entity.playerId == 1 then
            HymnGame.inputHandler:centerOn(entity.position.x, entity.position.y)
        end
    end

    ui.load()
end

function love.update(dt)
    HymnGame:update(dt)
    ui.update(dt)
    flux.update(dt)
end


function love.draw(dt)
    HymnGame:draw(dt)

    -- draw UI
    ui.draw(dt)
end

function love.keypressed(key, unicode)
    local altPressed = love.keyboard.isDown('lalt') or love.keyboard.isDown('ralt')
    if key == "escape" then
        -- sends quit event
        love.event.quit()
    end
    if key == 'return' and altPressed then
       fullscreen = not fullscreen
       love.window.setFullscreen(fullscreen, "desktop")
    end

    HymnGame.inputHandler:keyPressed(key, unicode)
end

function love.mousepressed(x, y, button)
    HymnGame.inputHandler:mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
    HymnGame.inputHandler:mouseReleased(x, y, button)
end

function love.focus(focussed)
end

function love.textinput(text)
end

function love.resize(w, h)
    ui.resize(w, h)
    HymnGame.map:resize(w, h)
end

return load
