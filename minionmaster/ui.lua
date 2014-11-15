local state = require "minionmaster.state"

local smallFont = love.graphics.newFont("fonts/Edson_Comics_Bold.ttf", 28)
local mediumFont = love.graphics.newFont("fonts/Edson_Comics_Bold.ttf", 45)

local ui = {}

function ui.load()
end

function ui.update(dt)
end

function ui.draw()
    -- DNA
    love.graphics.setFont(mediumFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("DNA: " .. state.dna, 12, 12)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("DNA: " .. state.dna, 10, 10)
end

return ui
