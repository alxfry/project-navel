local Building = require "shared.building"
local LogicCore = require "hymn.logiccore"
local EntityStatics = require "hymn.staticdata.entitystatics"
local GameMath = require "shared.gamemath"

local Deposit = Building:subclass("Deposit")

function Deposit:initialize(entityStatic)
    Building.initialize(self, entityStatic, player)

    self.claims = {}
    for playerId, player in pairs(LogicCore.players) do
        self.claims[playerId] = 0
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

function Deposit:takeOwnership(player)
    if self.owner then
        self.owner = self.owner.resource - 50
    end

    player.resource = player.resource + 50
    self.owner = player
end

function Deposit:claim(entity, amount)
    local playerId = entity.player.playerId
    local maxClaim = 0

    for id, current in pairs(self.claims) do
        local diff = (id == playerId) and amount or -amount
        self.claims[id] = GameMath.clamp(current + diff, 0, 100)
        if id ~= playerId then
            maxClaim = math.max(maxClaim, self.claims[id])
        end
    end

    dbgprint(table.concat(self.claims, ", "))

    local ownClaim = self.claims[playerId]

    if maxClaim == 0 and ownClaim > 50 then
        self:takeOwnership(entity.player)
    end
end

return Deposit