local GameComponent = require "smee.game_core.gamecomponent"
local loveframes    = require("libs.loveframes")
local table         = require("skoa_sandbox.utl.table")

local UiComponent = GameComponent:subclass("UiComponent")

local instance

local battlefieldQuery = function(entity)
    if entity:getComponent("BattlefieldComponent") then
        return true
    end
    return false
end

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

local function onEndTurnClick()
    -- GET BATTLEFIELD
    local game = SMEE.GetGame()
    local entityManager = game.entityManager
    local battlefield = entityManager:findAllEntities(battlefieldQuery)
    -- ONLY EXACTLY 1 BATTLEFIELD ALLOWED
    assert(#battlefield < 2 , "More than 1 battlefield found")
    assert(#battlefield > 0 , "No battlefield found")
    -- END TURN
    battlefield[1]:getComponent("BattlefieldComponent"):nextUnitRound()
end

local buttons = {
    { name = "Attack",      onClickFunction = onAttackClick,    iconPath = "/skoa_sandbox/resources/ui_pictures/icon_attack.png" },
    { name = "Move",        onClickFunction = onMoveClick,      iconPath = "/skoa_sandbox/resources/ui_pictures/icon_move.png" },
    { name = "Ability",     onClickFunction = onUseAbilityClick,iconPath = "/skoa_sandbox/resources/ui_pictures/icon_useability.png" },
    { name = "End Turn",    onClickFunction = onEndTurnClick,   iconPath = "/skoa_sandbox/resources/ui_pictures/icon_endturn.png" },
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
    self.unitStatsGrid = loveframes.Create("list")
    --self.unitStatsGrid:SetRows(4):SetColumns(2):SetCellWidth(75)
    for idx, textUiConfig in ipairs(textUiConfigs) do
        local titleText = loveframes.Create("text")
        titleText:SetText(textUiConfig.title)
        self.unitStatsGrid:AddItem(titleText, idx, 1)
    end
    self.unitStatsGrid:SetHeight(100)
    --self.unitStatsGrid:SetWidth(200)
    form:AddItem(self.unitStatsGrid)
    
    -- Create command buttons
    local resources = SMEE.GetGame():getResources()
    for idx, buttonDef in ipairs(buttons) do
        local button = loveframes.Create("imagebutton")
        button:SetSize(100, 100):SetText(buttonDef.name):SetEnabled(true):SetImage(buttonDef.iconPath)
        button.OnClick = buttonDef.onClickFunction
        form:AddItem(button)
    end
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
    
    local statsTextFields = self.unitStatsGrid:GetChildren()
    local textFieldHealth = statsTextFields[1]
    textFieldHealth:SetText("Health: " .. unitComponent.health .. "/" .. unitComponent.initialHealth)

    local textFieldDamage = statsTextFields[2]
    textFieldDamage:SetText("Damage: " .. unitComponent.damage)

    local textFieldDefense = statsTextFields[3]
    textFieldDefense:SetText("Defense: " .. unitComponent.defense)
    
    local textFieldSpeed = statsTextFields[4]
    textFieldSpeed:SetText("Speed: " .. unitComponent.walkSpeed)
    
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