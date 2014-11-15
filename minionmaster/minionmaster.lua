local Unit = require "shared.unit"

local MinionMaster = Unit:subclass("MinionMaster")

local content = require "minionmaster.content"
local state = require "minionmaster.state"

-- speed: pixels/second
function MinionMaster:initialize(entityStatics)
    Unit.initialize(self, entityStatics, state.player)

    self.joystick = love.joystick.getJoysticks()[1]
    self.type = "master"
end

function MinionMaster:update(dt)
    local moveX = (love.keyboard.isDown("d") and 2 or 0) - (love.keyboard.isDown("a") and 2 or 0)
    local moveY = (love.keyboard.isDown("s") and 2 or 0) - (love.keyboard.isDown("w") and 2 or 0) 

    if self.joystick then
        local x = self.joystick:getGamepadAxis("leftx")
        local y = self.joystick:getGamepadAxis("lefty")
        if math.abs(x) > 0.2 then moveX = moveX + x * 2 end
        if math.abs(y) > 0.2 then moveY = moveY + y * 2 end
    end

    self:moveTo(self.position.x + moveX, self.position.y + moveY)
    Unit.update(self, dt)
    self:updateMove(dt)
end

function MinionMaster:draw(dt)
    local x, y = self.position.x, self.position.y
    love.graphics.setColor(0, 0, 255, 255)
    love.graphics.circle("fill", x, y, self.radius, self.radius)
    love.graphics.setColor(255, 255, 255, 255)
end

function MinionMaster:takeDamage(dmg)
    -- print("masterdmg")
    -- self.health = self.health - dmg
end

return MinionMaster
