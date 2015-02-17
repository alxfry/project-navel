local GameComponent = require "smee.game_core.gamecomponent"
local GameMath      = require "smee.logic.gamemath"
local Entity        = require "smee.game_core.entity"

local InputHandler = GameComponent:subclass("InputHandler")

function InputHandler:initialize()
    local game = SMEE.GetGame()
    assert(game.entityManager, "The Game has no entityManager GameComponent, which is required for this input handler")
    self.entityManager = game.entityManager
end

function InputHandler:keyPressed(key, unicode)

end

function InputHandler:mousePressed(x, y, button)
    if button == "l" then
        local clickPos = GameMath.Vector2:new(x,y)
        local clickedEntities = self.entityManager:findAllEntities(Entity.wasClicked, clickPos)
        for k, v in pairs(clickedEntities) do
            dbgprint(v.id, v.position.x, v.position.y)
        end
    end
end

function InputHandler:mouseReleased(x, y, button)

end

return InputHandler