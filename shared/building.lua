local Entity = require "shared.entity"
local Building = Entity:subclass("Building")

-- speed: pixels/second
-- direction: radians
function Building:initialize(gfx)
    Entity.initialize(self)

    local img = love.graphics.newImage("images/buildings/frost/" .. gfx .. ".png")
    self.animation = newAnimation(img, 126, 126, 0.1, 0)
end

function Building:update(dt)
    Entity.update(self, dt)
end

return Building