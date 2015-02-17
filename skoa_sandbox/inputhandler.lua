local GameComponent = require "smee.game_core.gamecomponent"
local GameMath      = require "smee.logic.gamemath"
local Entity        = require "smee.game_core.entity"
local CollisionComponent = require "skoa_sandbox.entitycomponents.collisioncomponent"

local InputHandler = GameComponent:subclass("InputHandler")

function InputHandler:initialize()
    local game = SMEE.GetGame()
    assert(game.entityManager, "The Game has no entityManager GameComponent, which is required for this input handler")
    self.entityManager = game.entityManager
    
    assert(game.uiComponent, "The Game has no UI component, which is required for this input handler")
    self.uiComponent = game.uiComponent
end

function InputHandler:keyPressed(key, unicode)

end

function InputHandler:mousePressed(x, y, button)
    if button == "l" then
        local clickPos = GameMath.Vector2:new(x,y)
        local clickedEntities = self.entityManager:findAllEntities(CollisionComponent.static.checkClicked, clickPos)
        for k, v in pairs(clickedEntities) do
            self.uiComponent:unitClicked(v)
        end
    end
end

function InputHandler:mouseReleased(x, y, button)

end

return InputHandler