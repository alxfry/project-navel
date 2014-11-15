local Class = require "shared.middleclass"
local GameMath = require "shared.gamemath"
local InputHandler = Class "InputHandler"

function InputHandler:initialize(unit)
    self.unit = unit

    self.translate = GameMath.Vector2:new(0, 0)
end

local borderWidth = 20
local scrollSpeed = 500

function InputHandler:update(dt)
    local width, height = love.graphics.getDimensions()
    local x, y = love.mouse.getPosition()

    if x < borderWidth then
        self.translate.x = self.translate.x + scrollSpeed * dt
    elseif x > width - borderWidth then
        self.translate.x = self.translate.x - scrollSpeed * dt
    end

    if y < borderWidth then
        self.translate.y = self.translate.y + scrollSpeed * dt
    elseif y > height - borderWidth then
        self.translate.y = self.translate.y - scrollSpeed * dt
    end

    self.translate.x = GameMath.clamp(self.translate.x, -width, width)
    self.translate.y = GameMath.clamp(self.translate.y, -height, height)
end

function InputHandler:mousePressed(x, y, button)
    -- print("mousePressed", x, y, button)
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