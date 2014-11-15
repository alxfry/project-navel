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

local inputHandler
local entityManager

local function load()
    love.window.setTitle("Hymn of Snow and Lava")
    love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })
	entityManager = LogicCore.entityManager

    Player.entityManager = entityManager
    local player1 = Player:new()
    local player2 = Player:new()

    local myBuilding = SpawnPortal:new()
    entityManager:add(myBuilding)
    myBuilding:setPosition(170, 209)
    myBuilding:setPlayer(player1)

    local hisBuilding = SpawnPortal:new()
    entityManager:add(hisBuilding)
    hisBuilding:setPosition(700, 109)
    hisBuilding:setPlayer(player2)

    local myUnit = DecayingUnit:new(300, 0)
    myUnit:setPosition(baseHeight/4, baseHeight/3)
    entityManager:add(myUnit)
    myUnit:setPlayer(player1)

    local hisUnit = DecayingUnit:new(300, 0)
    hisUnit:setPosition(baseHeight/3, baseHeight/4)
    entityManager:add(hisUnit)
    hisUnit:setPlayer(player2)

    -- TODO: inputHandler = LogicCore.inputHandler
    inputHandler = InputHandler:new(myUnit)

    LogicCore:startMap(sti.new("testmap"))
end

function love.update(dt)
    LogicCore.entityManager:update(dt)
    LogicCore.inputHandler:update(dt, map)
    LogicCore.map:update(dt)
end

function love.draw(dt)
    LogicCore.map:draw()
    local width, height = love.graphics.getDimensions()
    -- Draw Range culls unnecessary tiles
    LogicCore.map:setDrawRange(inputHandler.translateX, inputHandler.translateY, width, height)

    -- love.graphics.translate(translateX, translateY)
    -- map:setDrawRange(inputHandler.translateX, inputHandler.translateY, width, height)

    love.graphics.translate(inputHandler.translateX, inputHandler.translateY)
    LogicCore.map:draw()
    entityManager:draw(dt)
end

function love.keypressed(key, unicode)
	if key == "escape" then
        -- sends quit event
        love.event.quit()
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
