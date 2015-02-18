local EntityComponent   = require "smee.game_core.entitycomponent"
local GameMath          = require "smee.logic.gamemath"

local MovementComponent = EntityComponent:subclass("MovementComponent")

local MOVE_SPEED = 1/200 -- Speed: seconds needed by pixels moved
-- function MovementComponent:update(dt)
-- end

function MovementComponent:moveTo(movePos)
    local distance = GameMath.Vector2.distance(self.owner.position, movePos)
    dbgprint(distance)
    local timeToMove = distance * MOVE_SPEED
    dbgprint(timeToMove)
    SMEE.Flux.to(self.owner.position, timeToMove, { x = movePos.x, y = movePos.y })
end

return MovementComponent