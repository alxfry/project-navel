local GameComponent = require "smee.game_core.gamecomponent"
local GameMath      = require "smee.logic.gamemath"
local Entity        = require "smee.game_core.entity"
local CollisionComponent = require "sandbox.entitycomponents.collisioncomponent"
local CombatLogic   = require "sandbox.combatlogic"

local InputHandler = GameComponent:subclass("InputHandler")

InputHandler.States = {
    Select = 1,
    Attack = 2,
    Move = 3,
    UseAbility = 4,
}

function InputHandler:initialize()
    local game = SMEE.GetGame()
    self.game = game
    
    assert(game.entityManager, "The Game has no entityManager GameComponent, which is required for this input handler")
    self.entityManager = game.entityManager
    
    assert(game.uiComponent, "The Game has no UI component, which is required for this input handler")
    self.uiComponent = game.uiComponent
    self.uiComponent:registerInputController(self)
    
    assert(game.entityManager, "The Game has no entity manager, which is required for this input handler")
    self.entityManager = game.entityManager
    
    self.currentState = InputHandler.States.Select
end

function InputHandler:prepareAttack(entity)
    self.currentState = InputHandler.States.Attack
    self.actingEntity = entity
end

function InputHandler:prepareMove(entity)
    self.currentState = InputHandler.States.Move
    self.actingEntity = entity
end

function InputHandler:prepareUseAbility(entity)
    self.currentState = InputHandler.States.UseAbility
    self.actingEntity = entity
end

function InputHandler:keyPressed(key, unicode)

end

function InputHandler:mousePressed(x, y, button)
    if button == "l" then
        self.uiComponent:mousepressed(x, y, button)
    
        local clickPos = GameMath.Vector2:new(x,y)
        local clickedEntities = self.entityManager:findAllEntities(CollisionComponent.static.checkClicked, clickPos)
        for k, entity in pairs(clickedEntities) do
            if self.currentState == InputHandler.States.Select then
                self.uiComponent:unitSelected(entity)
            elseif self.currentState == InputHandler.States.Attack then
                CombatLogic.performAttack(self.game.currentEncounter, self.actingEntity, entity)
                self.currentState = InputHandler.States.Select
                self.actingEntity = nil
            elseif self.currentState == InputHandler.States.Move then
                --TODO AMD: Perform move
                self.currentState = InputHandler.States.Select
                self.actingEntity = nil
            elseif self.currentState == InputHandler.States.UseAbility then
                --TODO AMD: Perform attack
                self.currentState = InputHandler.States.Select
                self.actingEntity = nil
            end
        end
    end
end

function InputHandler:mouseReleased(x, y, button)
    self.uiComponent:mousereleased(x, y, button)
end

return InputHandler