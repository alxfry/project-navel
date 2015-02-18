local GameComponent = require "smee.game_core.gamecomponent"
local Entity        = require "smee.game_core.entity"

local InputHandler = GameComponent:subclass("InputHandler")

function InputHandler:initialize()
    local game = SMEE.GetGame()
    self.game = game
    
    assert(game.entityManager, "The Game has no entityManager GameComponent, which is required for this input handler")
    self.entityManager = game.entityManager
    
    assert(game.uiComponent, "The Game has no UI component, which is required for this input handler")
    self.uiComponent = game.uiComponent
    
    assert(game.entityManager, "The Game has no entity manager, which is required for this input handler")
    self.entityManager = game.entityManager
end

function InputHandler:keyPressed(key, unicode)

end

function InputHandler:mousePressed(x, y, button)
    if button == "l" then
        self.uiComponent:mousepressed(x, y, button)
    end
end

function InputHandler:mouseReleased(x, y, button)
    self.uiComponent:mousereleased(x, y, button)
end

return InputHandler