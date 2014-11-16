local ui = {}

function ui.drawHealthBar(entity)
    local width = 40
    local height = 5
    local x = entity.position.x - width/2
    local y = entity.position.y - 30
    love.graphics.setColor(0, 16, 0, 255)
    love.graphics.rectangle("fill", x-1, y-1, width+2, height+2 )
    love.graphics.setColor(0, 128, 0, 255)
    love.graphics.rectangle("fill", x, y, width*entity.health/entity.maxHealth, height)
    love.graphics.setColor(255, 255, 255, 255)
end

function ui.drawProgress(entity)
    local width = 50
    local height = 5
    local x = entity.position.x - width/2
    local y = entity.position.y + 30
    love.graphics.setColor(16, 16, 0, 255)
    love.graphics.rectangle("fill", x-1, y-1, width+2, height+2 )
    love.graphics.setColor(250, 233, 50, 255)
    love.graphics.rectangle("fill", x, y, width*entity.health/entity.maxHealth, height)
    love.graphics.setColor(255, 255, 255, 255)
end

local PlayerColors = {
    { 18, 11, 239, 255 },
    { 206, 3, 3, 255 },
}

function ui.drawOwner(entity)
    local width = 50
    local height = 5
    local x = entity.position.x - width/2
    local y = entity.position.y + 30

    -- background
    love.graphics.setColor(16, 16, 16, 255)
    love.graphics.rectangle("fill", x-1, y-1, width+2, height+2 )

    local startX = x
    for playerId, percent in pairs(entity.claims) do
        local color = PlayerColors[playerId]
        local barWidth = percent/100*width
        local endX = startX + barWidth
        love.graphics.setColor(color[1], color[2], color[3], color[4])
        love.graphics.rectangle("fill", startX, y, barWidth, height)
        startX = endX
    end
    love.graphics.setColor(255, 255, 255, 255)
end

return ui
