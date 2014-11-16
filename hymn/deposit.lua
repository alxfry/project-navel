local Building = require "shared.building"
local LogicCore = require "hymn.logiccore"
local EntityStatics = require "hymn.staticdata.entitystatics"

local Deposit = Building:subclass("Deposit")

function Deposit:initialize(entityStatic)
    Building.initialize(self, entityStatic, player)

    self.owners = {}
    for playerId, player in pairs(LogicCore.players) do
        self.owners[playerId] = 0
    end

    self:setAnimation("images/buildings/resourcesrock_neutral.png", 1)
end

local themes = {
    "frost",
    "lava",
}

function Deposit:update(dt)
    Building.update(self, dt)

    if somethingInterestingHappens then
        -- change ownership
        self:setAnimation("images/buildings/" .. self.theme .. "/resourcesrock.png", 0.1)
    end
end

return Deposit