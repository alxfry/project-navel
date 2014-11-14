require "cupid"

local lg = love.graphics

local SplashScreen = require "screens/splash"
local ArenaScreen = require "screens/arena"
local Player = require "player"
local Sprite = require "sprite"
local ControllerHandler = require("controllerhandler")

local screen = SplashScreen
local baseWidth, baseHeight = 1920, 1080
local mouseCursor
local fullscreen = false

function love.load()
    love.window.setMode(baseWidth/2, baseHeight/2, { centered = true, resizable = true })
	love.mouse.setVisible(false)
	mouseCursor = lg.newImage("images/ui/mouseCursor.png")
    FontSmallSize = lg.newFont("fonts/Edson_Comics_Bold.ttf", 28)
    FontMidSize = lg.newFont("fonts/Edson_Comics_Bold.ttf", 45)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    math.randomseed(os.time())
    ControllerHandler:load()
    Sprite.load()
    Player.load()
    SplashScreen.load()
    ArenaScreen.load()
end

function love.update(dt)
    ControllerHandler:update(dt)
    screen = screen.update(dt)
end

function love.draw()
    local w, h = love.window.getDimensions()
    local scale = math.min(w/baseWidth, h/baseHeight)
    local dx, dy = 0, 0
    if w/baseWidth < h/baseHeight then
        dy = (h-baseHeight*scale)/2
    else
        dx = (w-baseWidth*scale)/2
    end
    love.graphics.translate(dx, dy)
    love.graphics.scale(scale, scale)
    ControllerHandler:setTransform(dx, dy, scale, scale)
    
    screen.draw()
	lg.setColor(255, 255, 255, 255)

    if screen == SplashScreen or ControllerHandler:isKeyboardActive() then
    	lg.draw(mouseCursor,
    	   (love.mouse.getX() - dx) / scale - mouseCursor:getWidth() / 4,
    	   (love.mouse.getY() - dy) / scale - mouseCursor:getHeight() / 4,
    		nil, 0.5, 0.5)
	end	
end

function love.keypressed(key, unicode)
	if key == 'escape' then
		love.event.push('quit')
	elseif key == 'f5' then
		love.load()
	end
	local altPressed = love.keyboard.isDown('lalt') or love.keyboard.isDown('ralt')
	if key == 'return' and altPressed then
       fullscreen = not fullscreen
	   love.window.setFullscreen(fullscreen, "desktop")
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
