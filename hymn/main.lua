local flux          = require "libs.flux"

local InputHandler = require "hymn.inputhandler"

local baseWidth, baseHeight = 1920, 1080
local Entity = require "shared.entity"
local EntityManager = require "shared.entitymanager"
local Player = require "shared.player"
local BehaviorTree = require "shared.behaviortree"
local sti = require "libs.sti"

local MapLoader = require "shared.maploader"
local LogicCore = require "hymn.logiccore"
local DecayingUnit = require "hymn.decayingunit"
local SpawnPortal = require "hymn.spawnportal"
local Deposit = require "hymn.deposit"
local GameMath = require "shared.gamemath"

local EntityStatics = require "hymn.staticdata.entitystatics"

local ui = require "hymn.ui"
local inputHandler = LogicCore.inputHandler
local entityManager

local function hauntedIslandsMap()
    local myBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[1])
    entityManager:add(myBuilding)
    myBuilding:setPosition(170, 209)
    myBuilding:addPathPoint(GameMath.Vector2:new(766, 975))
    myBuilding:instantBuild()

    -- local hisBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[2])
    -- entityManager:add(hisBuilding)
    -- hisBuilding:setPosition(790, 920)
    -- hisBuilding:addPathPoint(GameMath.Vector2:new(257, 204))
    -- hisBuilding:instantBuild()

    -- local theDeposit = Deposit:new(EntityStatics.deposit)
    -- entityManager:add(theDeposit)
    -- theDeposit:setPosition(790, 209)

    LogicCore:startMap(sti.new("maps/hauntedislands"))
end

local function lostTempleMap()
    local myBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[1])
    entityManager:add(myBuilding)
    myBuilding:setPosition(2570, 209)
    myBuilding:addPathPoint(GameMath.Vector2:new(1766, 975))
    myBuilding:instantBuild()

    -- local hisBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[2])
    -- entityManager:add(hisBuilding)
    -- hisBuilding:setPosition(790, 920)
    -- hisBuilding:addPathPoint(GameMath.Vector2:new(257, 204))
    -- hisBuilding:instantBuild()

    local theDeposit = Deposit:new(EntityStatics.deposit)
    entityManager:add(theDeposit)
    theDeposit:setPosition(790, 209)

    LogicCore:startMap(sti.new("maps/losttemple"))
end

local function spawn(object, x, y)
    local entity
    if object.id == 0 then
        entity = Deposit:new(EntityStatics.deposit)
    elseif object.id == 1 then
        entity = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[1])
        entity:instantBuild()
    elseif object.id == 2 then
        entity = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[2])
        entity:instantBuild()
    end

    if entity then
        entityManager:add(entity)
        entity:setPosition(x, y)
    end
end

local function load()
    love.window.setTitle("Hymn of Snow and Lava")
    love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })
	entityManager = LogicCore.entityManager

    local mapLoader = MapLoader:new("losttemple", spawn)
    LogicCore:startMap(mapLoader.map)

    -- hauntedIslandsMap()
    -- lostTempleMap()

    -- pan to own base
    for id, entity in pairs(entityManager.entities) do
        if entity.selectable and entity.player.playerId == 1 then
            inputHandler:centerOn(entity.position.x, entity.position.y)
        end
    end

    ui.load()

end

local function isPlayer1Entity(entity)
    if entity.player == LogicCore.players[1] then
        return true
    else
        return false
    end
end

local function isPlayer2Entity(entity)
    if entity.player == LogicCore.players[2] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if LogicCore.state == "running" then
        LogicCore.entityManager:update(dt)
        LogicCore.inputHandler:update(dt, LogicCore.map)
        LogicCore.map:update(dt)

        local playerEntities = LogicCore.entityManager:findAllEntities(isPlayer2Entity)
        if #playerEntities == 0 then
            dbgprint("PLAYER WINS")
            LogicCore.state = "gameover"
        end
        ui.update(dt)
    elseif LogicCore.state == "gameover" then
    end
    flux.update(dt)
end


function love.draw(dt)
    local width, height = love.graphics.getDimensions()

    -- draw map
    love.graphics.translate(inputHandler.translate.x, inputHandler.translate.y)
    -- Draw Range culls unnecessary tiles
    LogicCore.map:setDrawRange(inputHandler.translate.x, inputHandler.translate.y, width, height)
    LogicCore.map:draw()
    -- require "shared.blocking":draw()

    -- draw entities
    entityManager:draw(dt)

    -- debug printing the entity paths
    for id, entity in pairs(entityManager.entities) do
        if entity.drawPath then
            -- entity:drawPath()
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
