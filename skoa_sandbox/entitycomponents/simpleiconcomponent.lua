local EntityComponent = require "smee.game_core.entitycomponent"

local SimpleIconComponent = EntityComponent:subclass("SimpleIconComponent")

function SimpleIconComponent:init(owner, componentStatics)
    EntityComponent.init(self, owner)
    local resources = SMEE.GetGame():getResources()
    self.iconPath = componentStatics.iconPath
    resources.images[self.iconPath] = love.graphics.newImage(self.iconPath)
    self.icon = resources.images[self.iconPath]
    self.width = componentStatics.width
    self.height = componentStatics.height
    self.scaleX = self.width / self.icon:getWidth()
    self.scaleY = self.height / self.icon:getHeight()
end

function SimpleIconComponent:draw(dt)
    love.graphics.draw(self.icon, self.owner.position.x, self.owner.position.y, 0, self.scaleX, self.scaleY)
end

return SimpleIconComponent