local screen = SplashScreen
local baseWidth, baseHeight = 1920, 1080
local mouseCursor
local fullscreen = false



function love.load(arg)
    if arg[3] == "hymn" then
        require "HymnOfSnowAndMagma.main"()
    else
        print "get a main, biatches!"
    end
end
