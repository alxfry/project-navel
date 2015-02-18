local GameComponent         = require "smee.game_core.gamecomponent"
local loveframes            = require("libs.loveframes")
local table                 = require("sandbox.utl.table")
local GameMath              = require "smee.logic.gamemath"
local CombatLogic           = require "sandbox.combatlogic"
local CollisionComponent    = require "sandbox.entitycomponents.collisioncomponent"

local UiComponent = GameComponent:subclass("UiComponent")

local instance

local States = {
    Select = 1,
    Attack = 2,
    Move = 3,
    UseAbility = 4,
}

local battlefieldQuery = function(entity)
    if entity:getComponent("BattlefieldComponent") then
        return true
    end
    return false
end

local function onAttackClick()
    if instance.selectedUnit then
        if instance.currentState == States.Attack then
            instance.currentState = States.Select
        else
            instance.currentState = States.Attack
            instance.actorUnitComponent = instance.selectedUnit:getComponent("UnitComponent")
        end
    end
end

local function onMoveClick()
    dbgprint("onMoveClick()")

    if instance.selectedUnit then
        if instance.currentState == States.Move then
            dbgprint("State was MOVE, so i set it to SELECT")
            instance.currentState = States.Select
        else
            print("Set State to MOVE")
            instance.currentState = States.Move
            instance.actorUnitComponent = instance.selectedUnit:getComponent("UnitComponent")
        end
    end
end

local function onUseAbilityClick()
    if instance.selectedUnit then
        if instance.currentState == States.UseAbility then
            instance.currentState = States.Select
        else
            instance.currentState = States.UseAbility
            instance.actorUnitComponent = instance.selectedUnit:getComponent("UnitComponent")
        end
    end
end

local function onEndTurnClick()
    -- GET BATTLEFIELD
    local entityManager = SMEE.GetGame().entityManager
    local battlefield = entityManager:findAllEntities(battlefieldQuery)
    -- ONLY EXACTLY 1 BATTLEFIELD ALLOWED
    assert(#battlefield < 2 , "More than 1 battlefield found")
    assert(#battlefield > 0 , "No battlefield found")
    -- END TURN
    battlefield[1]:getComponent("BattlefieldComponent"):nextUnitRound()
end

local buttons = {
    { name = "Attack",      onClickFunction = onAttackClick,    iconPath = "/sandbox/resources/ui_pictures/icon_attack.png" },
    { name = "Move",        onClickFunction = onMoveClick,      iconPath = "/sandbox/resources/ui_pictures/icon_move.png" },
    { name = "Ability",     onClickFunction = onUseAbilityClick,iconPath = "/sandbox/resources/ui_pictures/icon_useability.png" },
    { name = "End Turn",    onClickFunction = onEndTurnClick,   iconPath = "/sandbox/resources/ui_pictures/icon_endturn.png" },
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

    local game = SMEE.GetGame()
    self.game = game
    assert(game.entityManager, "The Game has no entityManager GameComponent, which is required for this input handler")
    self.entityManager = game.entityManager

    self.currentState = States.Select

    local screenWidth, screenHeight = love.graphics.getDimensions()
    local unitDetails = loveframes.Create("frame")
    self.unitDetails = unitDetails
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

    if self.currentState == States.Move then
        love.graphics.setColor(0, 0, 0, 64)
        local pos = self.selectedUnit.position
        love.graphics.circle("fill", pos.x, pos.y, self.actorUnitComponent.walkSpeed)
        love.graphics.setColor(0xff, 0xff, 0xff, 0xff)
    elseif self.currentState == States.Attack then
        local pos = self.selectedUnit.position
        love.graphics.setColor(128, 0, 0, 64)
        local pos = self.selectedUnit.position
        love.graphics.circle("fill", pos.x, pos.y, self.actorUnitComponent.attackRange)
        love.graphics.setColor(0xff, 0xff, 0xff, 0xff)
    elseif self.currentState == States.UseAbility then
        love.graphics.setColor(128, 128, 0, 64)
        local pos = self.selectedUnit.position
        love.graphics.circle("fill", pos.x, pos.y, self.actorUnitComponent.attackRange)
        love.graphics.setColor(0xff, 0xff, 0xff, 0xff)
    else
        return
    end
    
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

    if y < self.unitDetails.y then
        local clickPos = GameMath.Vector2:new(x,y)
        if self.currentState == States.Move then
            dbgprint("Moving unit")
            CombatLogic.performMove(self.game.currentEncounter, self.selectedUnit, clickPos)
            self.currentState = States.Select
        else
            local clickedEntities = self.entityManager:findAllEntities(CollisionComponent.static.checkClicked, clickPos)
            for k, entity in pairs(clickedEntities) do
                if self.currentState == States.Select then
                    self:unitSelected(entity)
                elseif self.currentState == States.Attack then
                    CombatLogic.performAttack(self.game.currentEncounter, self.selectedUnit, entity)
                    self.currentState = States.Select
                elseif self.currentState == States.UseAbility then
                    --TODO AMD: Perform attack
                    self.currentState = States.Select
                end
            end
        end
    end

end

function UiComponent:textinput(text)
    loveframes.textinput(text)
end

return UiComponent
