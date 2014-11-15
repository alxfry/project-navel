-- Documentation:
-- https://love2d.org/wiki/Config_Files

local baseWidth, baseHeight = 1920, 1080

function love.conf(t)
    t.title = "SpiceMinons Engine"

    t.version = "0.9.0" -- results in a warning if the user has a different version of Love2D installed

    t.console = false -- Attach a console (boolean, Windows only)

    t.modules.physics = false

    t.window.fullscreen = false
    t.window.resizable = true
    t.window.vsync = true
    t.window.width = baseWidth/2
    t.window.height = baseHeight/2
end
