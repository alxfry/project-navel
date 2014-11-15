local Unit = require "shared.unit"
local blocking = require "shared.blocking"
local GameMath = require "shared.gamemath"

local MinionMaster = Unit:subclass("MinionMaster")

local content = require "minionmaster.content"
local state = require "minionmaster.state"

-- speed: pixels/second
function MinionMaster:initialize(entityStatics)
    Unit.initialize(self, entityStatics, state.player)

    self.joystick = love.joystick.getJoysticks()[1]
    self.type = "master"
    self:setAnimation("images/summoner/summon.png", 0.2)
end

function MinionMaster:update(dt)
    local move = GameMath.Vector2:new(0,0)
    move.x = (love.keyboard.isDown("d") and 1 or 0) - (love.keyboard.isDown("a") and 1 or 0)
    move.y = (love.keyboard.isDown("s") and 1 or 0) - (love.keyboard.isDown("w") and 1 or 0) 

    if self.joystick then
        local x = self.joystick:getGamepadAxis("leftx")
        local y = self.joystick:getGamepadAxis("lefty")
        if math.abs(x) > 0.2 then move.x = move.x + x end
        if math.abs(y) > 0.2 then move.y = move.y + y end
    end

    move:normalize()
    local newPosition = self.position + move * dt * self.speed
    if not blocking.collides(newPosition.x, newPosition.y) then
        self.position = newPosition
    end

    -- Update orientation
    if move:sqLength() > 0 then
        self.orientation = math.atan2(move.y, move.x)
    end

    Unit.update(self, dt)
end

function MinionMaster:takeDamage(dmg)
    -- print("masterdmg")
    self.health = self.health - dmg
end

return MinionMaster
