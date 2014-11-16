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
    self:setAnimation("images/summoner/walk.png", 0.175)
    self.summoning = false
end

function MinionMaster:update(dt)
    if self.health <= 0 then
        state.entityManager:remove(self.id)
        state.status = "game over"
        return
    end

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
        if not self.summoning then
            if move.x == 0 and move.y == 0 then
                self.animation:pauseAtStart()
            elseif self.animation.status == "paused" then
                self.animation:gotoFrame(2)
                self.animation:resume()
            end
        end
        self:setPosition(newPosition.x, newPosition.y)
    end

    -- Update orientation
    if move:sqLength() > 0 then
        self.orientation = math.atan2(move.y, move.x)
    end

    Unit.update(self, dt)
end

function MinionMaster:stopSummon()
    self.entity.summoning = false
    self.entity:setAnimation("images/summoner/walk.png", 0.175)
end

function MinionMaster:summon()
    self.summoning = true
    self:setAnimation("images/summoner/summon.png", 0.175)
    self.animation:gotoFrame(2)
    self.animation.onLoop = self.stopSummon
    self.animation.entity = self
end

return MinionMaster
