-- Central access point for game content
local function initialize()
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

    for guid, data in pairs(joystickMappings) do
        for _, mapping in pairs(data) do
            local type = mapping[1]
            local number = mapping[2]
            local button = mapping[3]
            love.joystick.setGamepadMapping(guid, button, type, number)
        end
    end
end

initialize()