local GameComponent = require "smee.game_core.gamecomponent"

local MapComponent = GameComponent:subclass("MapComponent")

function MapComponent:initialize(image)
    self.windowWidth, self.windowHeight = love.graphics.getDimensions()
    self.image = image
    self.scaleWidth, self.scaleHeight = self.windowWidth / self.image:getWidth(), self.windowHeight / self.image:getHeight()
end

function MapComponent:draw()
    love.graphics.draw(self.image,0,0,0,self.scaleWidth, self.scaleHeight)
end

return MapComponent