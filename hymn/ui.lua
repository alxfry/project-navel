local quickie = require "libs.quickie"
local LogicCore = require "hymn.logiccore"
local ui = {}

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
end

function ui.update(dt)
    quickie.group.push{grow = "down", pos = {5,5}}

    if quickie.Checkbox { checked = ui.clicked, text = "A test checkbox" } then
        ui.clicked = not ui.clicked
        print("click")
    end
end

function ui.draw()
    love.graphics.translate(-LogicCore.inputHandler.translate.x, -LogicCore.inputHandler.translate.y)

    quickie.core.draw()
end

return ui
