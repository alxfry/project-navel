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

local EntityStatics = require "hymn.staticdata.entitystatics"

local inputHandler
local entityManager

local function load()
    love.window.setTitle("Hymn of Snow and Lava")
    love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })
	entityManager = LogicCore.entityManager

    -- local myBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[1])
    -- entityManager:add(myBuilding)
    -- myBuilding:setPosition(170, 209)

    -- local hisBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[2])
    -- entityManager:add(hisBuilding)
    -- hisBuilding:setPosition(700, 109)

    -- local myUnit = DecayingUnit:new(EntityStatics.basicDecayMinion, LogicCore.players[1])
    -- myUnit:setPosition(baseHeight/4, baseHeight/3)
    -- entityManager:add(myUnit)

    -- local hisUnit = DecayingUnit:new(EntityStatics.basicDecayMinion, LogicCore.players[2])
    -- hisUnit:setPosition(baseHeight/3, baseHeight/4)
    -- entityManager:add(hisUnit)

    inputHandler = LogicCore.inputHandler
    -- inputHandler = InputHandler:new(myUnit)

    LogicCore:startMap(sti.new("testmap"))
end

function love.update(dt)
    LogicCore.entityManager:update(dt)
    LogicCore.inputHandler:update(dt, LogicCore.map)
    LogicCore.map:update(dt)
end

local cursor = love.graphics.newImage("images/ui/mouseCursor.png")
local pathFlag = love.graphics.newImage("images/ui/heart.png")

function love.draw(dt)
    LogicCore.map:draw()
    local width, height = love.graphics.getDimensions()
    -- Draw Range culls unnecessary tiles
    LogicCore.map:setDrawRange(inputHandler.translate.x, inputHandler.translate.y, width, height)
    love.graphics.translate(inputHandler.translate.x, inputHandler.translate.y)
    LogicCore.map:draw()
    entityManager:draw(dt)

    local entity = inputHandler.selectedEntityId and entityManager.entities[inputHandler.selectedEntityId]
    if entity then
        love.graphics.draw(cursor, entity.position.x-96, entity.position.y-96)
        if entity.path then
            local startPoint = entity.position
            for _, endPoint in ipairs(entity.path) do
                love.graphics.line(startPoint.x, startPoint.y, endPoint.x, endPoint.y)
                love.graphics.draw(pathFlag, endPoint.x-18, endPoint.y-18)
                startPoint = endPoint
            end
        end
    end
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
    LogicCore.map:resize(w, h)
end

return load
