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
    local width = 40
    local height = 5
    local x = entity.position.x - width/2
    local y = entity.position.y + 30
    love.graphics.setColor(16, 16, 0, 255)
    love.graphics.rectangle("fill", x-1, y-1, width+2, height+2 )
    love.graphics.setColor(250, 233, 50, 255)
    love.graphics.rectangle("fill", x, y, width*entity.health/entity.maxHealth, height)
    love.graphics.setColor(255, 255, 255, 255)
end

return ui
