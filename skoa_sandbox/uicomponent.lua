local GameComponent = require "smee.game_core.gamecomponent"
local loveframes    = require("libs.loveframes")
local table         = require("skoa_sandbox.utl.table")

local UiComponent = GameComponent:subclass("UiComponent")

local instance

local function onAttackClick()
    dbgprint("onAttackClick()")

    instance.inputController:prepareAttack(instance.selectedUnit)
end

local function onMoveClick()
    instance.inputController:prepareMove(instance.selectedUnit)
end

local function onUseAbilityClick()
    instance.inputController:prepareUseAbility(instance.selectedUnit)
end

local buttons = {
    { name = "Attack", icon = "...", onClickFunction = onAttackClick },
    { name = "Move", icon = "...", onClickFunction = onMoveClick },
    { name = "Ability", icon = "...", onClickFunction = onUseAbilityClick },
}

local textUiConfigs = {
    { title = "Health" },
    { title = "Damage" },
    { title = "Defense" },
    { title = "Speed" },
}

function UiComponent:initialize()
    assert(not instance, "UiComponent is a Singleton!!")
    instance = self

    local screenWidth, screenHeight = love.graphics.getDimensions()
    local unitDetails = loveframes.Create("frame")
    self.unitDataContainer = unitDetails
    unitDetails:SetName("Click on a unit to see its details"):SetSize(screenWidth, 150):SetDraggable(false):ShowCloseButton(false)
    unitDetails:SetPos(0, screenHeight - unitDetails:GetHeight())
    
    -- Create form to add UI elements from left to right.
    local form = loveframes.Create("form", unitDetails)
    form:SetPos(5, 25)
    form:SetSize(unitDetails:GetWidth(), 100):SetName("Overview")
    form:SetLayoutType("horizontal")
    
    -- Create grid with unit stats.
    self.unitStatsGrid = loveframes.Create("grid")
    self.unitStatsGrid:SetRows(4):SetColumns(2):SetCellWidth(50)
    for idx, textUiConfig in ipairs(textUiConfigs) do
        local titleText = loveframes.Create("text")
        titleText:SetText(textUiConfig.title)
        self.unitStatsGrid:AddItem(titleText, idx, 1)
        
        local valueText = loveframes.Create("text")
        valueText:SetText("0")
        self.unitStatsGrid:AddItem(valueText, idx, 2)
    end
    self.unitStatsGrid:SetHeight(100)
    form:AddItem(self.unitStatsGrid)
    form:SetWidth(form:GetWidth() + self.unitStatsGrid:GetWidth())
    
    -- Create command buttons
    for idx, buttonDef in ipairs(buttons) do
        local button = loveframes.Create("button")
        button:SetSize(100, 100):SetText(buttonDef.name):SetEnabled(true)
        button.OnClick = buttonDef.onClickFunction
        form:AddItem(button)
    end

    self.selectedUnit = nil
end

---
-- The input controller must provide functions for prepareAttack, prepareMove and prepareUseAbility.
function UiComponent:registerInputController(inputController)
    assert(inputController.prepareAttack, "Could not find function 'prepareAttack'!")
    assert(inputController.prepareMove, "Could not find function 'prepareMove'!")
    assert(inputController.prepareUseAbility, "Could not find function 'prepareUseAbility'!")
    
    self.inputController = inputController
end

function UiComponent:unitSelected(unitEntity)
    -- Unselect former selected unit.
    if self.selectedUnit then
        local simpleIconComponent = self.selectedUnit:getComponent("SimpleIconComponent")
        if simpleIconComponent then
            simpleIconComponent.selected = false
        end
    end
    self.selectedUnit = unitEntity

    local unitComponent = unitEntity:getComponent("UnitComponent")
    
    self.unitDataContainer:SetName(unitComponent.name)
    
    local textFieldHealth = self.unitStatsGrid:GetItem(1, 2)
    textFieldHealth:SetText(unitComponent.health)

    local textFieldDamage = self.unitStatsGrid:GetItem(2, 2)
    textFieldDamage:SetText(unitComponent.damage)

    local textFieldDefense = self.unitStatsGrid:GetItem(3, 2)
    textFieldDefense:SetText(unitComponent.defense)
    
    local textFieldSpeed = self.unitStatsGrid:GetItem(4, 2)
    textFieldSpeed:SetText(unitComponent.walkSpeed)
    
    local simpleIconComponent = unitEntity:getComponent("SimpleIconComponent")
    if simpleIconComponent then
        simpleIconComponent.selected = true
    end

    self.selectedUnit = unitEntity
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
    dbgprint("UiComponent:mousepressed(x, y, button)")
    
    loveframes.mousepressed(x, y, button)
end

function UiComponent:mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function UiComponent:textinput(text)
    loveframes.textinput(text)
end

return UiComponent