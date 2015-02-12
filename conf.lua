-- Documentation:
-- https://love2d.org/wiki/Config_Files

local baseWidth, baseHeight = 1280, 720

function love.conf(t)
    t.title = "SpiceMinons Engine"

    t.version = "0.9.0" -- results in a warning if the user has a different version of Love2D installed

    t.console = false -- Attach a console (boolean, Windows only)

    t.modules.physics = false

    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.resizable = false
    t.window.vsync = true
    t.window.width = baseWidth
    t.window.height = baseHeight
end
