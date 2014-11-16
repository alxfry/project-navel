local Class = require "shared.middleclass"
local Player = require "shared.player"
local HymnPlayer = Class("HymnPlayer", Player)

function HymnPlayer:initialize()
    self.resource = 200
    Player.initialize(self)
end

return HymnPlayer