local ControllerHandler = require "controllerhandler"
local Level = require "level"
local Player = require "player"
local Sprite = require "sprite"
local Flext = require "flext"
local Music = require "music"
local Grenade = require "grenade"
local Sound = require "sound"
local Music = require "music"
local Splatter = require "splatter"

local lg = love.graphics

local playerWithHighestNumberOfKills
local controllerMapping = {}

local M = {}

local maxHealth = 10
local maxCooldown = 5
local uiImageCrown, uiImageHeart
local uiImagePlayers = {}
local uiPlayerInfoOffsets = {
    {x = 906, y = 572},
    {x = 992, y = 492},
    {x = 906, y = 412},
    {x = 820, y = 492},
}

M.load = function()
    uiImageCrown = lg.newImage("images/ui/crown.png")
    uiImageHeart = lg.newImage("images/ui/heart.png")
    uiImagePlayers[1] = lg.newImage("images/ui/playerGreen.png")
    uiImagePlayers[2] = lg.newImage("images/ui/playerRed.png")
    uiImagePlayers[3] = lg.newImage("images/ui/playerYellow.png")
    uiImagePlayers[4] = lg.newImage("images/ui/playerBlue.png")
end

M.draw = function()
    lg.setColor(255, 255, 255, 255)
    Level.draw()
    Splatter.draw()
    Sprite.draw()
    Grenade.draw()
    Flext.draw()
    
    -- find player with highest number of kills
    local playerWithHighestNumberOfKills
    local currentHighestNumber = 0
    
    for c,p in pairs(controllerMapping) do
        if c.stats.kills > currentHighestNumber then
            currentHighestNumber = c.stats.kills
            playerWithHighestNumberOfKills = c.colorIndex
        elseif c.stats.kills == currentHighestNumber then
            playerWithHighestNumberOfKills = nil
        end
    end
    
    -- draw player color
    for i = 1, 4 do
        local offsetX, offsetY = uiPlayerInfoOffsets[i].x, uiPlayerInfoOffsets[i].y
        local uiImagePlayer = uiImagePlayers[i]
        lg.setColor(255, 255, 255, 255)
        lg.draw(uiImagePlayer, offsetX + 22, offsetY + 24, nil, 0.5, 0.5)
    end
		
    for c,p in pairs(controllerMapping) do
        local offsetX, offsetY = uiPlayerInfoOffsets[c.colorIndex].x, uiPlayerInfoOffsets[c.colorIndex].y
		
        -- draw player kills
        lg.setColor(0, 0, 0, 255)
        local killsFormattedNumber = c.stats.kills or 0
        if killsFormattedNumber < 10 then
            killsFormattedNumber = "0" .. tostring(killsFormattedNumber)
        end
        love.graphics.setFont(FontSmallSize)
        lg.print(killsFormattedNumber or 0, offsetX + 38, offsetY + 2)
        
        -- draw player lives
        lg.setColor(255, 255, 255, 255)
        if c.stats.lives > 0 then
            lg.draw(uiImageHeart, offsetX + 32, offsetY + 80, nil, 0.5, 0.5)
        end
        if c.stats.lives > 1 then
            lg.draw(uiImageHeart, offsetX + 52, offsetY + 80, nil, 0.5, 0.5)
        end
        
        -- draw player health (max.: 10)
        local healthBarWidth, healthBarHeight = 10, 54
        -- health bar bg
        lg.setColor(140, 35, 60, 255)
        lg.rectangle("fill", offsetX + 12, offsetY + 24, healthBarWidth, healthBarHeight)
        -- health bar
        lg.setColor(255, 50, 100, 255)
		local healthBarOffset = ((maxHealth - c.stats.health) / maxHealth) * healthBarHeight
        lg.rectangle("fill", offsetX + 12, offsetY + 24 + healthBarOffset, healthBarWidth, healthBarHeight * (c.stats.health / maxHealth))
        
        -- draw player cooldown (3 - 0)
        -- cooldown bar bg
        lg.setColor(37, 36, 87, 255)
        lg.rectangle("fill", offsetX + 80, offsetY + 24, healthBarWidth, healthBarHeight)
        -- cooldown bar
        lg.setColor(37, 95, 255, 255)
		local cooldownBarOffset = ((c.stats.cooldown or 0) / maxCooldown) * healthBarHeight
        lg.rectangle("fill", offsetX + 80, offsetY + 24 + cooldownBarOffset, healthBarWidth, healthBarHeight * ((maxCooldown - (c.stats.cooldown or 0)) / maxCooldown))
        
        -- draw crown over player with highest number of kills
        if playerWithHighestNumberOfKills == c.colorIndex then
            lg.setColor(255, 255, 255, 255)
            lg.draw(uiImageCrown, offsetX + 34, offsetY - 22, nil, 0.5, 0.5)
        end
    end

    --[[    
    local p = Player.get(1)
    if p then -- debugging for blocking
        local px, py = p.pos.x, p.pos.y
        local input = p.controller:getData(px, py)
        local angle = input.aim.angle
        local dx = math.sin(angle + math.rad(180)) * 300
        local dy = math.cos(angle + math.rad(180)) * 300
        Level.trace(px, py, px - dx, py + dy)
    end
    --]]

end

local weapons =
{
    machinegun = {
        weapon = "machinegun",
        owner = c,
        createSound = "shoot",
        projectileSpeed = 1000,
        fragmentExpiry = 0.8,
        cooldown = 0.13,
        fragmentImage = lg.newImage("images/projectiles/shotMachinegun.png"),
    },
    grenade = {
        weapon = "grenade",
        expiry = 1,
        owner = c,
        createSound = "swoosh",
        explodeSound = "bomb",
        cooldown = 1,
        projectileSpeed = 300,
        fragmentExpiry = 0.5,
        projectileImage = lg.newImage("images/projectiles/weaponGrenade.png"),
        projectileImageScale = 0.2,
        fragmentImage = lg.newImage("images/projectiles/weaponGrenadeSplinter.png"),
    },
    bomb = {
        weapon = "bomb",
        expiry = 1.5,
        owner = c,
        createSound = "birdshoot",
        explodeSound = "cannon",
        projectileSpeed = 0,
        fragmentExpiry = 0.6,
        cooldown = 1,
        projectileImage = lg.newImage("images/projectiles/weaponBomb.png"),
        projectileImageScale = 0.35,
        fragmentImage = lg.newImage("images/projectiles/weaponBombParticle.png"),
    },
}

local selectedWeapon = "machinegun"

M.update = function(dt)
    -- find player with highest number of kills
    
    local currentHighestNumber = 0
    for c,p in pairs(controllerMapping) do
        c.stats.isKing = false
        if c.stats.kills > currentHighestNumber then
            currentHighestNumber = c.stats.kills
            playerWithHighestNumberOfKills = c
        elseif c.stats.kills == currentHighestNumber then
            playerWithHighestNumberOfKills = nil
        end
    end
    
    if playerWithHighestNumberOfKills then
        playerWithHighestNumberOfKills.stats.isKing = true
        playerWithHighestNumberOfKills = playerWithHighestNumberOfKills.colorIndex
    end
    
    
    for c,p in pairs(controllerMapping) do
        if c.stats.cooldown then
            c.stats.cooldown = c.stats.cooldown - dt
            if c.stats.cooldown <= 0 then
                c.stats.cooldown = nil
            end
        end
        if c.stats.weaponCooldown then
            c.stats.weaponCooldown = c.stats.weaponCooldown - dt
            if c.stats.weaponCooldown <= 0 then
                c.stats.weaponCooldown = nil
            end
        end
        if c.stats.health <= 0 then
            c:vibrate(2.0, 2.0)
            if c.stats.lives > 0 then
                c.stats.health = maxHealth
                c.stats.lives = c.stats.lives - 1
                local char = p.character
                Player.destroy(p)
                local p = Player.create("", char)
                p.controller = c
                controllerMapping[c] = p
            else
                Sound.play("gameover") -- game over sound
                Player.destroy(p)
                p = nil
                controllerMapping[c] = nil
            end
        end
    end
    
    for c,p in pairs(controllerMapping) do
        local input = c:getData(p.pos.x, p.pos.y)
        if not c.stats.cooldown then
            local switchTo
            for tc,tp in pairs(controllerMapping) do
                if tc ~= c and input.switch[tc.colorIndex] then
                    switchTo = tc
                end
            end
            if switchTo then
                c.stats.cooldown = maxCooldown
            --[[
                controllerMapping[c] = controllerMapping[switchTo]
                p.controller = switchTo
                controllerMapping[switchTo] = p
                controllerMapping[c].controller = c
            --]]
                local newPos = controllerMapping[switchTo].pos
                controllerMapping[switchTo].pos = controllerMapping[c].pos 
                controllerMapping[c].pos = newPos
            elseif input.ability[2] then
                c.stats.cooldown = maxCooldown
                selectedWeapon = next(weapons,selectedWeapon) or next(weapons)
                print("weapon switch: "..selectedWeapon.."!")
                Music.setTrackPreset(selectedWeapon)
            end
        end
        if not c.stats.weaponCooldown and input.ability[1] then
            local props = weapons[selectedWeapon]
            local weaponOffset = 20 --remember to change to hit area offset in player.lua as well
            Grenade.create(p.pos.x,p.pos.y-weaponOffset,input.aim.x*props.projectileSpeed,input.aim.y*props.projectileSpeed,props, c)
            c.stats.weaponCooldown = props.cooldown
            if not c.stats.cooldown or props.cooldown > c.stats.cooldown then
                c.stats.cooldown = props.cooldown
            end
        end
    end
    
    Player.update(dt)
    Sprite.update(dt)
    Grenade.update(dt)
    Flext.update(dt)
    Music.update(dt)
    Splatter.update(dt)
    
    local i = ControllerHandler:getControllers()

    for id,c in pairs(i) do
        if not controllerMapping[c] and c:activating() then
            c.stats = {health = maxHealth, lives = 2, kills = 0}
            local p = Player.create()
            p.controller = c
            controllerMapping[c] = p
        end
    end

    return M
end

M.mousepressed = function(x,y,button)
end

M.mousereleased = function(x,y,button)
end

return M