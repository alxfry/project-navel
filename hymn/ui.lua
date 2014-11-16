local quickie = require "libs.quickie"
local LogicCore = require "hymn.logiccore"

local sharedui = require "shared.ui"

local ui = {}

local inputHandler
local entityManager

local selectionCircle = love.graphics.newImage("images/ui/selectionCircle.png")
local pathFlag = love.graphics.newImage("images/ui/waypoint.png")

function ui.load()
    -- preload fonts
    fonts = {
        [12] = love.graphics.newFont("fonts/Edson_Comics_Bold.ttf", 28),
        [20] = love.graphics.newFont("fonts/Edson_Comics_Bold.ttf", 45),
    }
    love.graphics.setBackgroundColor(17,17,17)
    love.graphics.setFont(fonts[12])

    -- group defaults
    quickie.group.default.size[1] = 150
    quickie.group.default.size[2] = 25
    quickie.group.default.spacing = 5

    inputHandler = LogicCore.inputHandler
    entityManager = LogicCore.entityManager

    ui.windowWidth, ui.windowHeight = love.graphics.getDimensions()
end

function ui.update(dt)
    love.graphics.setColor(0, 0, 0, 255)
    quickie.Label { pos = { ui.windowWidth - 200, ui.windowHeight - 40 }, text = "Spice: " .. LogicCore.players[1].resource }
    quickie.Label { pos = { ui.windowWidth - 350, ui.windowHeight - 40 }, text = "rate: " .. 400/LogicCore.players[1].resource }

    if quickie.Button { text = "Build", pos = { 10, ui.windowHeight - 40 } } then
        inputHandler:setMode("build")
    end
    if inputHandler.selection and quickie.Button { text = "Path", pos = { 170, ui.windowHeight - 40 } } then
        inputHandler:setMode("path")
    end
end

function ui.draw()
    love.graphics.translate(inputHandler.translate.x, inputHandler.translate.y)

    for id, entity in pairs(entityManager.entities) do
        if entity.health then
            sharedui.drawHealthBar(entity)
        end
    end

    -- draw selection
    local entity = inputHandler.selection and entityManager.entities[inputHandler.selection]
    if entity then
        love.graphics.draw(selectionCircle, entity.position.x-126/2, entity.position.y-126/2)
        if entity.path then
            local startPoint = entity.position
            for _, endPoint in ipairs(entity.path) do
                love.graphics.line(startPoint.x, startPoint.y, endPoint.x, endPoint.y)
                love.graphics.draw(pathFlag, endPoint.x-8, endPoint.y-8)
                startPoint = endPoint
            end
        end
    end

    love.graphics.translate(-inputHandler.translate.x, -inputHandler.translate.y)
    love.graphics.rectangle("fill", 0, ui.windowHeight - 50, ui.windowWidth, 50)
    quickie.core.draw()
end

function ui.resize(w, h)
    ui.windowWidth = w
    ui.windowHeight = h
end

return ui
