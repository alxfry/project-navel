local EntityComponent   = require "smee.game_core.entitycomponent"
local GameMath          = require "smee.logic.gamemath"

local MovementComponent = EntityComponent:subclass("MovementComponent")

local MOVE_SPEED = 1/200 -- Speed: seconds needed by pixels moved
-- function MovementComponent:update(dt)
-- end

function MovementComponent:moveTo(movePos)
    local distance = GameMath.Vector2.distance(self.owner.position, movePos)
    -- dbgprint(distance)
    local timeToMove = distance * MOVE_SPEED
    SMEE.Flux.to(self.owner.position, timeToMove, { x = movePos.x, y = movePos.y }) 
    -- dbgprint(timeToMove)
end

function MovementComponent:getDistanceInAP(distance)
    local unitComponent = self.owner.componentsMap["UnitComponent"]
    if not unitComponent then
        return 0
    end
    if unitComponent.walkRate == 0 then
        return 0
    end

    return math.ceil(distance/unitComponent.walkRate)
end

return MovementComponent