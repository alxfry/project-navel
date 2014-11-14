
ControllerTable = {}

------- Controller base class -------

Controller = { data = {}, stats = {} }

-- input: [optional] player coordinates
function Controller:getData(x, y)
    local data = {}
    data.move = {
        x = 0,
        y = 0,
    }
    data.aim = {
        angle = 0,
        x = 0,
        y = 0,    
    }
    data.ability = {
        [0] = true,
        [1] = false,
        [2] = false,
    }
    data.switch = true
    return data
end

local nextCid = -1

function Controller:new(o)
    o = o or {}   -- create object if user does not provide one
    print("ccreate "..nextCid)
    o.cid = nextCid
    o.colorIndex = o.cid%4+1
    o.data = {}
    nextCid = nextCid + 1
    setmetatable(o, self)
    self.__index = self
    return o
end

function Controller:vibrate(left, right)
end

------- Keyboard controller class -------

KeyboardController = Controller:new({ dx = 0, dy = 0, sx = 0, sy = 0 })

function KeyboardController:getData(x, y)
    x = x or 0
    y = y or 0

    local data = {}
    data.move = {
        x = (love.keyboard.isDown("d") and 1 or 0) - (love.keyboard.isDown("a") and 1 or 0),
        y = (love.keyboard.isDown("s") and 1 or 0) - (love.keyboard.isDown("w") and 1 or 0),
    }
    local dMove = math.sqrt(data.move.x * data.move.x + data.move.y * data.move.y)
    if dMove ~= 0 then
        data.move.x = data.move.x / dMove
        data.move.y = data.move.y / dMove
    end
    
    local aimX = ((love.mouse.getX() - self.dx)/self.sx) - x
    local aimY = ((love.mouse.getY() - self.dy)/self.sy) - y
    
    local d = math.sqrt(aimX * aimX + aimY * aimY)
    data.aim = {
        x = aimX/d,
        y = aimY/d,
    }
    data.aim.angle = math.atan2(aimX, -aimY)
    data.ability = {
        [1] = love.keyboard.isDown("q") or love.mouse.isDown("l"),
        [2] = love.keyboard.isDown("e") or love.mouse.isDown("r"),
    }
    data.switch = {
        [1] = love.keyboard.isDown("1"),
        [2] = love.keyboard.isDown("2"),
        [3] = love.keyboard.isDown("3"),
        [4] = love.keyboard.isDown("4"),
    }
    
    return data
end

function KeyboardController:activating()
    return love.keyboard.isDown(" ")
end

------- XBox controller class -------

XboxController = Controller:new()

function XboxController:getData()
    local moveX = self.joystick:getGamepadAxis("leftx")
    local moveY = self.joystick:getGamepadAxis("lefty")
    local dMove = math.sqrt(moveX * moveX + moveY * moveY)
    local moving = dMove > 0.2
    self.data.move = {
        x = moving and moveX/dMove or 0,
        y = moving and moveY/dMove or 0,
    }

    local aimX = self.joystick:getGamepadAxis("rightx")
    local aimY = self.joystick:getGamepadAxis("righty")
    local dAim = math.sqrt(aimX * aimX + aimY * aimY)
    
    local d
    if dAim >= 0.5 then
        d = math.sqrt(aimX * aimX + aimY * aimY)
    elseif dMove >= 0.5 then
        d = math.sqrt(moveX * moveX + moveY * moveY)
        aimX = moveX
        aimY = moveY
    end

    if not d and not self.data.aim then
        d = 1
        aimX = moveX
        aimY = moveY
    end

    if d then
        self.data.aim = {
            x = aimX/d,
            y = aimY/d,
        }
        self.data.aim.angle = math.atan2(aimX, -aimY)
    end

    self.data.ability = {
        [1] = self.joystick:isGamepadDown("rightshoulder"),
        [2] = self.joystick:isGamepadDown("leftshoulder"),
    }
    self.data.switch = {
        [1] = self.joystick:isGamepadDown("a"),
        [2] = self.joystick:isGamepadDown("b"),
        [3] = self.joystick:isGamepadDown("y"),
        [4] = self.joystick:isGamepadDown("x"),
    }
    
    return self.data
end

function XboxController:activating()
    return self.joystick:isGamepadDown("start")
end

function XboxController:vibrate(left, right)
    self.joystick:setVibration(left, right)
    self.vibrationTimer = math.max(0.5, (left+right)/4)
end

local joystickMappings = {
    -- Thrustmaster
    ["b5071503000000000000504944564944"] = {
        { "button", 1, "a" },
        { "button", 2, "x" },
        { "button", 3, "b" },
        { "button", 4, "y" },
        { "button", 5, "leftshoulder" },
        { "button", 6, "triggerleft" },
        { "button", 7, "rightshoulder" },
        { "button", 8, "triggerright" },
        { "button", 9, "back" },
        { "button", 10, "start" },
        { "button", 11, "leftstick" },
        { "button", 12, "rightstick" },
        { "axis", 1, "leftx" },
        { "axis", 2, "lefty" },
        { "axis", 4, "rightx" },
        { "axis", 3, "righty" },
    },
    
    --crappy generic gamepads
    ["8f0e1200000000000000504944564944"] = {
        { "button", 3, "a" },
        { "button", 2, "b" },
        { "button", 4, "x" },
        { "button", 1, "y" },
        { "button", 10, "start" },
        { "button", 9, "back" },
        { "button", 7, "leftshoulder" },
        { "button", 8, "rightshoulder" },
        { "button", 5, "triggerleft" },
        { "button", 6, "triggerright" },
        { "button", 11, "leftstick" },
        { "button", 12, "rightstick" },
    },
}

local function bindGameMappings()
    for guid, data in pairs(joystickMappings) do
        for _, mapping in pairs(data) do
            local type = mapping[1]
            local number = mapping[2]
            local button = mapping[3]
            love.joystick.setGamepadMapping(guid, button, type, number)
        end
    end
end

------- Controller Handler -------

local ControllerHandler = {}

function ControllerHandler:load()
    bindGameMappings()

    ControllerTable["keyboard"] = KeyboardController:new { id = "keyboard" }
    for i, joystick in ipairs(love.joystick.getJoysticks()) do
        local id = "joystick_" .. joystick:getID()
        ControllerTable[id] = XboxController:new {
            id = id,
            joystick = joystick
        }
    end
end

function ControllerHandler:update(dt)
    for id, controller in pairs(ControllerTable) do
        if not controller.isActive and controller:activating() then
            print("activating controller " .. id)
            controller.isActive = true
        end
        if controller.vibrationTimer then
            controller.vibrationTimer = controller.vibrationTimer - dt
            if controller.vibrationTimer <= 0 then
                controller:vibrate(0, 0)
                controller.vibrationTimer = false
            end
        end
    end
end

function ControllerHandler:getControllers()
    local inputs = {}
    for id, controller in pairs(ControllerTable) do
        if controller.isActive then
            inputs[controller.id] = controller
        end
    end
    return inputs
end

function ControllerHandler:setTransform(dx, dy, sx, sy)
    local c = ControllerTable["keyboard"]
    c.dx = dx
    c.dy = dy
    c.sx = sx
    c.sy = sy
end

function ControllerHandler:isKeyboardActive()
    return ControllerTable["keyboard"].isActive
end

return ControllerHandler
