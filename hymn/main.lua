local InputHandler = require "hymn.inputhandler"

local baseWidth, baseHeight = 1920, 1080
local Entity = require "shared.entity"
local EntityManager = require "shared.entitymanager"
local Player = require "shared.player"
local BehaviorTree = require "shared.behaviortree"
local sti = require "libs.sti"

local LogicCore = require "hymn.logiccore"
local DecayingUnit = require "hymn.decayingunit"
local SpawnPortal = require "hymn.spawnportal"
local GameMath = require "shared.gamemath"

local EntityStatics = require "hymn.staticdata.entitystatics"

local ui = require "hymn.ui"
local inputHandler = LogicCore.inputHandler
local entityManager

local function simpleLevel()
    local myBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[1])
    entityManager:add(myBuilding)
    myBuilding:setPosition(170, 209)
    myBuilding:addPathPoint(GameMath.Vector2:new(766, 975))

    -- local hisBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[2])
    -- entityManager:add(hisBuilding)
    -- hisBuilding:setPosition(790, 920)
    -- hisBuilding:addPathPoint(GameMath.Vector2:new(257, 204))
end

local function load()
    love.window.setTitle("Hymn of Snow and Lava")
    love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })
	entityManager = LogicCore.entityManager

    simpleLevel()

    ui.load()

    LogicCore:startMap(sti.new("testmap"))
end

function love.update(dt)
    LogicCore.entityManager:update(dt)
    LogicCore.inputHandler:update(dt, LogicCore.map)
    LogicCore.map:update(dt)
    ui.update(dt)
end


function love.draw(dt)
    local width, height = love.graphics.getDimensions()
    LogicCore.map:draw()

    -- draw map
    love.graphics.translate(inputHandler.translate.x, inputHandler.translate.y)
    -- Draw Range culls unnecessary tiles
    LogicCore.map:setDrawRange(inputHandler.translate.x, inputHandler.translate.y, width, height)
    LogicCore.map:draw()

    -- draw entities
    entityManager:draw(dt)

    -- debug printing the entity paths
    for id, entity in pairs(entityManager.entities) do
        if entity.drawPath then
            entity:drawPath()
        end
    end

    love.graphics.translate(-inputHandler.translate.x, -inputHandler.translate.y)

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

    inputHandler:keyPressed(key, unicode)
end

function love.mousepressed(x, y, button)
    inputHandler:mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
    inputHandler:mouseReleased(x, y, button)
end

function love.focus(focussed)
end

function love.textinput(text)
end

function love.resize(w, h)
    ui.resize(w, h)
    LogicCore.map:resize(w, h)
end

return load
