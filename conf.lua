
-- Documentation:
-- https://love2d.org/wiki/Config_Files

function love.conf(t)
    t.title = "Switcheroo"
    t.version = "0.9.0" -- results in a warning if the user has a different version of Love2D installed
    t.console = false -- Attach a console (boolean, Windows only)
    t.window.fullscreen = false
    t.window.vsync = true
    t.window.width = 1024
    t.window.height = 768
end
