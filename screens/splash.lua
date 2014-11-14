local Arena = require "screens/arena"

local lg = love.graphics
local bgImage, tagImage

local M = {}

M.load = function()
    bgImage = lg.newImage("images/startScreen/startScreen.jpg")
    tagImage = lg.newImage("images/startScreen/tag.png")
    M.fadeTimeout = 3
end

M.draw = function()    
    lg.draw(bgImage, 0, 0, 0, 0.5, 0.5)
    lg.setColor(255, 255, 255, 255*(1-M.fadeTimeout/3))
    lg.draw(tagImage, 0, 0, 0, 0.5, 0.5)
end

M.update = function(dt)
    -- check for mouseclick on button
    local baseWidth, baseHeight = 1920, 1080
    local w, h = love.window.getDimensions()
    local scale = math.min(w/baseWidth, h/baseHeight)
    
    local x = love.mouse.getX() / scale
    local y = love.mouse.getY() / scale
    
    if love.mouse.isDown('l')
    and x > 1450 and x < 1660 and y > 850 and y < 1020 then
        return Arena
    end
    
    -- check for gamepad button press 'A' or 'Start'
    local joysticks = love.joystick.getJoysticks( )
    
    for i, joystick in ipairs(joysticks) do
        if joystick:isGamepadDown('start')
        or joystick:isGamepadDown('a') then
            return Arena
        end
    end
    
    if M.fadeTimeout > 0 then
        M.fadeTimeout = math.max(0, M.fadeTimeout - dt)
    end
    
    
    return M
end

M.mousepressed = function(x, y, button)
end

M.mousereleased = function(x, y, button)
end

return M