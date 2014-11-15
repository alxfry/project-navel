require "libs.cupid"

local baseWidth, baseHeight = 1920, 1080
local mouseCursor
local fullscreen = false

local sti = require "libs.sti"

-- local Entity = require "shared.entity"
local EntityManager = require "shared.entitymanager"
-- local Unit = require "shared.unit"
local MinionMaster = require "minionmaster.minionmaster"
local Minion = require "minionmaster.minion"
local Enemy = require "minionmaster.enemy"

local master
local entityManager
local tick

local enemyCount = 10
local masterSpeed = 100
local minionSpeed = 150
local enemySpeed = 20
local enemyHealth = 100

local map

local zoom = 1
local zoomSpeed = 0.1

local enemies = {}

function findEnemy()
    local nearest = nil
    local minDist = 9999999999
    for i, enemy in ipairs(enemies) do
        local dist = (enemy.position - master.position):sqLength()
        if dist < minDist then
            minDist = dist
            nearest = enemy
        end
    end

    return nearest or master
end

function enemyDied(enemy)
    entityManager:remove(enemy.id)
    for i, _enemy in ipairs(enemies) do
        if _enemy == enemy then
            table.remove(enemies, i)
            break
        end
    end
end

local function load(arg)
    print("local load "..tostring(arg))
    mouseCursor = love.graphics.newImage("images/ui/mouseCursor.png")

    map = sti.new("testmap")

    entityManager = EntityManager:new()
    master = MinionMaster:new(masterSpeed)
    master:setPosition(baseWidth/4, baseHeight/4)
    entityManager:add(master)

    for i=1,enemyCount do
        local enemy = Enemy:new(enemySpeed, master, enemyHealth, enemyDied)
        enemy:setPosition(math.random(baseWidth/2),math.random(baseHeight/2))
        entityManager:add(enemy)
        table.insert(enemies, enemy)
    end
end

function love.update(dt)
    entityManager:update(dt)
end

function love.draw(dt)
    entityManager:draw(dt)

    local translateX = love.mouse.getX()
    local translateY = love.mouse.getY()
    -- print(translateX, translateY)
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.translate(translateX, translateY)

    map:setDrawRange(translateX, translateY, width, height)
    -- map:draw(zoom,zoom)

    love.graphics.translate(0, 0)
end

function love.keypressed(key, unicode)
	if key == "escape" then
        -- sends quit event
        love.event.quit()
    end

    if key == "m" then

        local minion = Minion:new(minionSpeed, findEnemy())
        minion:setPosition(master.position.x, master.position.y)
        entityManager:add(minion)
    end
end

function love.mousepressed(x, y, button)
    if button == "wd" then
        zoom = zoom - zoomSpeed
    elseif button == "wu" then
        zoom = zoom + zoomSpeed
    end
end

function love.mousereleased(x, y, button)
    -- screen.mousereleased(x,y, button)
end

function love.focus(focussed)
end

function love.textinput(text)
    -- GUI.textinput(text)
end

function love.resize(w, h)
    -- GUI.resize(w, h)
end

return load
