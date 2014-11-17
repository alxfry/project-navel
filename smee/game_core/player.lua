local Class = require "smee.libs.middleclass"
local Player = Class "Player"

Player.static.count = 1

function Player:initialize()
    self.playerId = Player.static.count
    Player.static.count = Player.static.count + 1
end

return Player