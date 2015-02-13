local GameComponent = require "smee.game_core.gamecomponent"

local InputHandler = GameComponent:subclass("InputHandler")

function InputHandler:keyPressed(key, unicode)
end

function InputHandler:mousePressed(x, y, button)
end

function InputHandler:mouseReleased(x, y, button)
end