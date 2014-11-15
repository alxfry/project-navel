-- Central access point for game content
local anim8 = require "libs.anim8" 

local content = 
{
    minion = 
    {
        image = nil,
        walk = nil,
        attack = nil,
    },

    building = 
    {
        image = nil,
        walk = nil,
        attack = nil,
    },
}

function content.load()
    -- local image = love.graphics.newImage("images/minion/frost/walk.png")
    -- local grid = anim8.newGrid(64, 64, image:getWidth(), image:getHeight())
    -- content.minion.image = image
    -- content.minion.walk = anim8.newAnimation(grid('1-3',1), 0.175)
    -- content.minion.attack = anim8.newAnimation(grid('1-3',1), 0.175)
end

return content