local flux          = require "smee.libs.flux"

local HymnGame      = require "hymn.logiccore"

-- local InputHandler = require "hymn.inputhandler"

local baseWidth, baseHeight = 1920, 1080
-- local Entity = require "smee.game_core.entity"
-- local EntityManager = require "smee.game_core.entitymanager"
-- local Player = require "smee.game_core.player"
-- local BehaviorTree = require "smee.logic.behaviortree"
-- local sti = require "smee.libs.sti"s
-- local MapLoader = require "smee.resource_management.maploader"
-- local GameMath = require "smee.logic.gamemath"

-- local LogicCore = require "hymn.logiccore"s
-- local DecayingUnit = require "hymn.decayingunit"
-- local SpawnPortal = require "hymn.spawnportal"s
-- local Deposit = require "hymn.deposit"

-- local EntityStatics = require "hymn.staticdata.entitystatics"

-- TODO Create UI Component
local ui = require "hymn.ui"
-- TODO Create InputHandler Component
-- local inputHandler = LogicCore.inputHandler
-- local entityManager

-- local function hauntedIslandsMap()
--     local myBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[1])
--     entityManager:add(myBuilding)
--     myBuilding:setPosition(170, 209)
--     myBuilding:addPathPoint(GameMath.Vector2:new(766, 975))
--     myBuilding:instantBuild()

--     -- local hisBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[2])
--     -- entityManager:add(hisBuilding)
--     -- hisBuilding:setPosition(790, 920)
--     -- hisBuilding:addPathPoint(GameMath.Vector2:new(257, 204))
--     -- hisBuilding:instantBuild()

--     -- local theDeposit = Deposit:new(EntityStatics.deposit)
--     -- entityManager:add(theDeposit)
--     -- theDeposit:setPosition(790, 209)

--     LogicCore:startMap(sti.new("maps/hauntedislands"))
-- end

-- local function lostTempleMap()
--     local myBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[1])
--     entityManager:add(myBuilding)
--     myBuilding:setPosition(2570, 209)
--     myBuilding:addPathPoint(GameMath.Vector2:new(1766, 975))
--     myBuilding:instantBuild()

--     -- local hisBuilding = SpawnPortal:new(EntityStatics.spawnPortal, LogicCore.players[2])
--     -- entityManager:add(hisBuilding)
--     -- hisBuilding:setPosition(790, 920)
--     -- hisBuilding:addPathPoint(GameMath.Vector2:new(257, 204))
--     -- hisBuilding:instantBuild()

--     local theDeposit = Deposit:new(EntityStatics.deposit)
--     entityManager:add(theDeposit)
--     theDeposit:setPosition(790, 209)

--     LogicCore:startMap(sti.new("maps/losttemple"))
-- end

local function load()
    love.window.setTitle("Hymn of Snow and Lava")
    love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })

    HymnGame:load("losttemple")
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
