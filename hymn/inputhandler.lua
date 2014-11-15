local Class = require "shared.middleclass"
local InputHandler = Class "InputHandler"

function InputHandler:initialize(unit)
    self.unit = unit
end

function InputHandler:mousePressed(x, y, button)
    -- print("mousePressed", x, y, button)
    self.unit:moveTo(x, y)
end

function InputHandler:mouseReleased(x, y, button)
    -- print("mouseReleased", x, y, button)
end

function InputHandler:keyPressed(key, unicode)
    -- print("keyPressed", key, unicode)
end


-- local SubClass =  Class("Subclass", InputHandler)
-- local InputHandler = Handler:subclass("InputHandler")

return InputHandler