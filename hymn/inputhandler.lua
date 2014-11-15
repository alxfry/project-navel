local Class = require "shared.middleclass"
local InputHandler = Class "InputHandler"

function InputHandler:initialize(unit)
    self.unit = unit

    self.translateX = 0
    self.translateY = 0
end

local borderWidth = 20
local scrollSpeed = 500

function InputHandler:update(dt, map)
    local width, height = love.graphics.getDimensions()
    local x, y = love.mouse.getPosition()

    if x < borderWidth then
        self.translateX = self.translateX + scrollSpeed * dt
    elseif x > width - borderWidth then
        self.translateX = self.translateX - scrollSpeed * dt
    end

    if y < borderWidth then
        self.translateY = self.translateY + scrollSpeed * dt
    elseif y > height - borderWidth then
        self.translateY = self.translateY - scrollSpeed * dt
    end
end

function InputHandler:mousePressed(x, y, button)
    -- print("mousePressed", x, y, button)
    self.unit:moveTo(x - self.translateX, y - self.translateY)
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