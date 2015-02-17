local GameComponent = require "smee.game_core.gamecomponent"
local loveframes    = require("libs.loveframes")

local UiComponent = GameComponent:subclass("UiComponent")

local buttons = {
    { name = "Attack", icon = "..." },
    { name = "Move", icon = "..." },
    { name = "Ability", icon = "..." },
}

local textUiConfigs = {
    { title = "Health" },
    { title = "Damage" },
    { title = "Defense" },
}

function UiComponent:initialize()
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local unitDetails = loveframes.Create("frame")
    unitDetails:SetName("Click on a unit to see its details"):SetSize(screenWidth, 150):SetDraggable(false):ShowCloseButton(false)
    unitDetails:SetPos(0, screenHeight - unitDetails:GetHeight())
    
    -- Create form to add UI elements from left to right.
    local form = loveframes.Create("form", unitDetails)
    form:SetPos(5, 25)
    form:SetSize(unitDetails:GetWidth(), 100):SetName("No Unit Selected")
    form:SetLayoutType("horizontal")
    
    -- Create grid with unit stats.
    local unitStats = loveframes.Create("grid")
    unitStats:SetRows(4):SetColumns(2):SetCellWidth(50)
    for idx, textUiConfig in ipairs(textUiConfigs) do
        local titleText = loveframes.Create("text")
        titleText:SetText(textUiConfig.title)
        unitStats:AddItem(titleText, idx, 1)
        
        local valueText = loveframes.Create("text")
        valueText:SetText("0")
        unitStats:AddItem(valueText, idx, 2)
    end
    unitStats:SetHeight(100)
    form:AddItem(unitStats)
    form:SetWidth(form:GetWidth() + unitStats:GetWidth())
    
    -- Create command buttons
    for idx, buttonDef in ipairs(buttons) do
        local button = loveframes.Create("imagebutton")
        button:SetSize(100, 100):SetText(buttonDef.name)
        form:AddItem(button)
    end
end

function UiComponent:draw()
    loveframes.draw()
end

function UiComponent:update(dt)
    loveframes.update(dt)
end

function UiComponent:keypressed(key, unicode)
    loveframes.keypressed(key, unicode)
end

function UiComponent:mousepressed(x, y, button)
    loveframes.mousepressed(x, y, button)
end

function UiComponent:mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function UiComponent:textinput(text)
    loveframes.textinput(text)
end


return UiComponent