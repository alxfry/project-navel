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

    love.graphics.push()
    love.graphics.translate(width - 110, height - 110)
    ui.drawRadar()
    love.graphics.pop()

    if state.status == "game over" then
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("GAME OVER", width/2 - 100 + 2, height/2 - 20 + 2)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("GAME OVER", width/2 - 100, height/2 - 20)
    end
end

function ui.drawRadar()
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 0, 0, 100, 20)
    local pos = state.master.position
    local range = 500
    local sqrRange = range * range
    local entitiesInRange = state.entityManager:findAllEntities(
        function(entity)
            return (entity.position - pos):sqLength() <= sqrRange
        end
        )

    love.graphics.setColor(255, 0, 0)
    for i, entity in ipairs(entitiesInRange) do
        local radarPos = (entity.position - pos) / range * 100
        if entity.type == "master" then
            love.graphics.setColor(0, 0, 255)
        elseif entity.type == "enemy" then
            love.graphics.setColor(255, 0, 0)
        else
            love.graphics.setColor(0, 255, 255)
        end
        love.graphics.circle("fill", radarPos.x, radarPos.y, 5, 8)
    end
end

return ui
