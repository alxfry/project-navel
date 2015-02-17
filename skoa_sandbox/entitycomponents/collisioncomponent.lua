local EntityComponent   = require "smee.game_core.entitycomponent"
local GameMath          = require "smee.logic.gamemath"

local CollisionComponent = EntityComponent:subclass("CollisionComponent")

CollisionComponent.static.checkClicked = function(entity, clickPos)
    -- dbgprint("checkClicked")
    local collisionComponent = entity.componentsMap["CollisionComponent"]
    local hasCollision = false
    if collisionComponent then
        -- dbgprint("checking AABB")
        hasCollision = collisionComponent.AABB:checkCollision(GameMath.AABB.Zero, entity.position, clickPos)
    end
    return hasCollision
end    

function CollisionComponent:initialize(owner)
    EntityComponent.initialize(self, owner)
    self.clickListeners = {}
    self.collisionListeners = {}
end

function CollisionComponent:init(owner, statics)
    EntityComponent.init(self, owner)
    local localX = statics.localX or 0
    local localY = statics.localY or 0
    self.AABB = GameMath.AABB:new(localX,localY,statics.width,statics.height)
    owner.checkClicked = CollisionComponent.static.checkClicked
end

function CollisionComponent:registerClickListener(callback)
    self.clickListeners[#self.clickListeners+1] = callback
end

function CollisionComponent:registerCollisionListener(callback)
    self.collisionListeners[#self.collisionListeners+1] = callback
end

function CollisionComponent:callClickListener()
    for i=1, #self.clickListeners do
        local current = self.clickListeners[i]
        current(self.owner)
    end
end


return CollisionComponent