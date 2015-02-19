local EntityComponent   = require "smee.game_core.entitycomponent"
local GameMath          = require "smee.logic.gamemath"

local ROOT_TWO = math.sqrt(2)

local CollisionComponent = EntityComponent:subclass("CollisionComponent")

CollisionComponent.static.checkClicked = function(entity, clickPos)
    local collisionComponent = entity.componentsMap["CollisionComponent"]
    local hasCollision = false
    if collisionComponent then
        hasCollision = collisionComponent.AABB:checkCollision(GameMath.AABB.Zero, entity.position, clickPos)
    end
    return hasCollision
end

-- find a position outside the entity closest to point
function CollisionComponent.static.closestPosition(entity, point)
    local collisionComponent = entity.componentsMap["CollisionComponent"]
    local direction = point - entity.position
    local length = collisionComponent.AABB.width
    direction:normalize()
    return length * direction + entity.position
end

local function findCloseEntitiesFilter(entity, position, ignoreList)
    local collisionComponent = entity.componentsMap["CollisionComponent"]

    if ignoreList[entity.id] then
        return false
    end

    if collisionComponent then
        local distance = GameMath.Vector2.distance(entity.position, position)
        return distance <= collisionComponent.AABB.width
    end

    return false
end

function CollisionComponent.static.findCloseEntities(position, ignoreList)
    return SMEE.GetGame().entityManager:findAllEntities(findCloseEntitiesFilter, position, ignoreList)
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