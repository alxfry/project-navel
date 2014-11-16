-- require "libs.cupid"

-- lock down the globals table for performance and error detection
setmetatable(_G, {
  __index = function(_, key)
    return error("no such global '" .. tostring(key) .. "'")
  end,
  __newindex = function(_, key, value)
    return error("creating global '" .. tostring(key) .. "' not allowed")
  end,
})

-- require "shared.controllerbindings"

local sti           = require "libs.sti"

local state         = require "minionmaster.state"
local ui            = require "minionmaster.ui"
local content       = require "minionmaster.content"

local Enemy         = require "minionmaster.enemy"
local Minion        = require "minionmaster.minion"
local MinionMaster  = require "minionmaster.minionmaster"

local blocking      = require "shared.blocking"

local UpgradeStatics = require "minionmaster.upgrades"

local baseWidth, baseHeight = 1920, 1080

local EntityStatics

local enemyCount = 10

local zoom = 1
local zoomSpeed = 0.1

local movingToMouse = false

local function spawnMinion(master)
    if state.dna >= EntityStatics.minion.cost then
        state.dna = state.dna - EntityStatics.minion.cost
        local minion = Minion:new(EntityStatics.minion, master)
        minion:setPosition(master.position.x, master.position.y)
        state.entityManager:add(minion)
    end
end

local function start()
    state.entityManager:clear()

    EntityStatics = state.entityStatics

    -- spawn the master
    state.master = MinionMaster:new(EntityStatics.master)
    state.master:setPosition(500,500)
    state.entityManager:add(state.master)

    -- spawnMinion(state.master)

    -- spawn initial enemies
    for i=1,enemyCount do
        local enemy = Enemy:new(EntityStatics.enemy, state.master)
        local sx, sy = state.map:size()
        local x, y = math.random(sx),math.random(sy)
        while blocking.collides(x, y) do
            x,y = math.random(sx),math.random(sy)
        end
        enemy:setPosition(x, y)
        state.entityManager:add(enemy)
    end
end

local function load()
    state.initialize()
    content.load()
    ui.load()
    start()
end

function love.update(dt)
    if state.status == "game over" then
        return
    end

    if movingToMouse then
        local posX = love.mouse.getX() - state.translateX
        local posY = love.mouse.getY() - state.translateY
        state.master:moveTo(posX, posY)
    end

    state.entityManager:update(dt)
    state.map:update(dt)
    ui.update(dt)
end

function love.draw(dt)
    local width, height = love.graphics.getDimensions()
    width = width / zoom
    height = height / zoom

    local translateX = -state.master.position.x + width / 2
    local translateY = -state.master.position.y + height / 2

    state.translateX = translateX
    state.translateY = translateY

    state.map:setDrawRange(translateX, translateY, width, height)
    love.graphics.push()
    love.graphics.scale(zoom, zoom)
    love.graphics.translate(translateX, translateY)
    state.map:draw()
    state.entityManager:draw(dt)

    -- debug printing the entity paths
    for id, entity in pairs(state.entityManager.entities) do
        if entity.drawPath then
            entity:drawPath()
        end
    end

    -- debug grid drawing
    blocking.draw()

    love.graphics.pop()

    ui.draw()
end

function love.keypressed(key, unicode)
	if key == "escape" then
        -- sends quit event
        love.event.quit()
    end

    if key == "m" then
        spawnMinion(state.master)
        state.master:summon()
    end

    if key == "r" then
        state.status = "playing"
        start()
    end

    if key == "h" then
        UpgradeStatics.apply(UpgradeStatics.healMaster, false, state.master)
    end

    if key == "u" then
        UpgradeStatics.apply(UpgradeStatics.damageUpMinion, true)
    end
end

function love.mousepressed(x, y, button)
    if button == "wd" then
        zoom = zoom - zoomSpeed
    elseif button == "wu" then
        zoom = zoom + zoomSpeed
    elseif button == "l" then
        if love.keyboard.isDown('rctrl') or love.keyboard.isDown('lctrl') then
            local posX = x - state.translateX
            local posY = y - state.translateY
            state.master:setPosition(posX, posY)
        else
            movingToMouse = true
        end
    end
end

function love.mousereleased(x, y, button)
    -- screen.mousereleased(x,y, button)
    if button == "l" then
        movingToMouse = false
    end
end

function love.gamepadpressed(joystick, button)
    if button == "a" then
        spawnMinion(state.master)
    end

    if key == "start" then
        state.status = "playing"
        start()
    end
end

function love.focus(focussed)
end

function love.textinput(text)
    -- GUI.textinput(text)
end

function love.resize(w, h)
    -- GUI.resize(w, h)
    state.map:resize(w, h)
end

return load
