local Class = require "shared.middleclass"

local EntityManager = require "shared.entitymanager"
local InputHandler  = require "hymn.inputhandler"

local blocking = require "shared.blocking"

-- LogicCore Class
local LogicCore = Class "LogicCore"

function LogicCore:initialize(eMng, iHdnlr)
    self.entityManager = eMng or  EntityManager:new(self)
    self.inputHandler = iHndlr or InputHandler:new(self)
    self.map = false
end

function LogicCore:startMap(map)
    self.map = map
    blocking.map = map
end

function LogicCore:reset()

end

-- LogicCore Singleton
local logicCore = LogicCore:new()

return logicCore

