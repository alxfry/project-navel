local Class = require "spiceminion_engine.libs.middleclass"
local Player = require "shared.player"
local HymnPlayer = Class("HymnPlayer", Player)

function HymnPlayer:initialize()
    self.resource = 200
    Player.initialize(self)
end

local themes = {
    "frost",
    "lava",
}

function HymnPlayer:theme()
    return themes[self.playerId] or themes[1]
end

return HymnPlayer