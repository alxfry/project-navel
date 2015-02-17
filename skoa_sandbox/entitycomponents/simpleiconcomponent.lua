local EntityComponent = require "smee.game_core.entitycomponent"

local SimpleIconComponent = EntityComponent:subclass("SimpleIconComponent")

function SimpleIconComponent:init(owner, componentStatics)
    EntityComponent.init(self, owner)
    local resources = SMEE.GetGame():getResources()
    self.iconPath = componentStatics.iconPath
    -- New löve2D image into GameResources
    resources.images[self.iconPath] = resources.images[self.iconPath] or love.graphics.newImage(self.iconPath)
    self.icon = resources.images[self.iconPath]
    -- some basic computations
    self.width = componentStatics.width
    self.height = componentStatics.height
    self.halfWidth = componentStatics.width / 2
    self.halfHeight = componentStatics.height / 2
    self.scaleX = self.width / self.icon:getWidth()
    self.scaleY = self.height / self.icon:getHeight()
end

function SimpleIconComponent:draw(dt)
    -- Draw the image centered to the entity
    love.graphics.draw(self.icon, self.owner.position.x - self.halfWidth, self.owner.position.y - self.halfHeight, 0, self.scaleX, self.scaleY)
end

return SimpleIconComponent