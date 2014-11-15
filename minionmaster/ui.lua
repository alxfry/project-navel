local state = require "minionmaster.state"

local smallFont = love.graphics.newFont("fonts/Edson_Comics_Bold.ttf", 28)
local mediumFont = love.graphics.newFont("fonts/Edson_Comics_Bold.ttf", 45)

local ui = {}

function ui.load()
end

function ui.update(dt)
end

function ui.draw()
    local width, height = love.graphics.getDimensions()

    -- DNA
    love.graphics.setFont(mediumFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("DNA: " .. state.dna, 12, 12)
    love.graphics.setColor(100, 100, 255)
    love.graphics.print("DNA: " .. state.dna, 10, 10)

    -- Master Health
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Health: " .. state.master.health, 12, height - 55)
    love.graphics.setColor(255, 100, 100)
    love.graphics.print("Health: " .. state.master.health, 10, height - 57)
end

return ui
