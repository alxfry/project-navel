local Class = require "shared.middleclass"
local Player = Class "Player"

Player.count = 0

function Player:initialize()
    self.playerId = Player.count
    Player.count = Player.count + 1
end

return Player