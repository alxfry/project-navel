local screen = SplashScreen
local baseWidth, baseHeight = 1920, 1080
local mouseCursor
local fullscreen = false

function love.load()
    love.filesystem.setSource("../")
    love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })
	mouseCursor = love.graphics.newImage("..\\image\\ui\\mouseCursor.png")
end

function love.update(dt)
end

function love.draw(dt)
end

function love.keypressed(key, unicode)
	if key == "escape" then
        -- sends quit event
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    screen.mousepressed(x,y, button)
end

function love.mousereleased(x, y, button)
    screen.mousereleased(x,y, button)
end

function love.focus(focussed)
end

function love.textinput(text)
    GUI.textinput(text)
end

function love.resize(w, h)
    GUI.resize(w, h)
end