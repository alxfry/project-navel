local EntityComponent = require "smee.game_core.entitycomponent"

local SimpleIconComponent = EntityComponent:subclass("SimpleIconComponent")

local function setSelected(entity)
    local simpleIconComponent = entity:getComponent("SimpleIconComponent")
    if simpleIconComponent then
        simpleIconComponent.selected = true
    end
end

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
    self.selected = false
    
    -- Find its unit component.
    self.actorUnitComponent = self.owner:getComponent("UnitComponent")
end

function SimpleIconComponent:draw(dt)
    -- Draw the image centered to the entity
    if self.selected then
        local oldColor = love.graphics.getColor()
        love.graphics.setColor(0,0,255)
        love.graphics.circle("fill", self.owner.position.x, self.owner.position.y, 35, 32)
        love.graphics.setColor(255,255,255)
    end
    
    love.graphics.draw(self.icon, self.owner.position.x - self.halfWidth, self.owner.position.y - self.halfHeight, 0, self.scaleX, self.scaleY)
    
    local healthString = self.actorUnitComponent.health .. "/" .. self.actorUnitComponent.initialHealth
    love.graphics.printf(healthString, self.owner.position.x - self.halfWidth, self.owner.position.y + self.height * 0.2, self.width, 'center')
end

return SimpleIconComponent