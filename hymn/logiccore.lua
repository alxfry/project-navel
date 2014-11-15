local Class = require "shared.middleclass"

local EntityManager = require "shared.entitymanager"
local InputHandler 	= require "hymn.inputHandler"

-- LogicCore Class
local LogicCore = Class "LogicCore"

function LogicCore:initialize(eMng, iHdnlr)
	self.entityManager = eMng or  EntityManager:new()
	self.inputHandler = iHndlr or InputHandler:new()
	self.map = false
end

function LogicCore:startMap(map)
	self.map = map
end

function LogicCore:reset()

end

-- LogicCore Singleton
local logicCore = LogicCore:new()

return logicCore

