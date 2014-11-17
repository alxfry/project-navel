local EntityManager = require "smee.game_core.entitymanager"

local EntityLayer = Class "EntityLayer"

function EntityLayer:initialize(name)
	self.name = name
	self.visible = true
	self.entities = {}
end

function EntityLayer:setVisibile(bool)
	self.visible = bool
end

local LayeredEntityManager = EntityManager:subclass("LayeredEntityManager")

function LayeredEntityManager:initialize(game)
	EntityManager.initialize(self, game)

	self.layers = {}
	self.eIdToLayer = {}
end

function LayeredEntityManager:draw(dt)
	-- DO NOT CALL SUPERCLASS DRAW: We add our own draw code
	local layers = self.layers
	for i = 1, #layers do
		local currentLayer = layers[i]
		if currentLayer.visible then
			for k = 1, #currentLayer do
				local entity = currentLayer.entities[k]
				entity:draw(dt)
			end
		end
	end
end

function LayeredEntityManager:add(entity, layer)
	EntityManager.add(self, entity)

	if type(layer) == "number" then
		local targetLayer = self.layers[layer]
		self.eIdToLayer[entity.id] = layer
		table.insert(targetLayer.entities, entity)
		return true
	end

	if type(layer) == "string" then
		local layers = self.layers
		for i = 1, #layers do
			if layers[i].name == layer then
				table.insert(layers[i], entity)
				self.eIdToLayer[entity.id] = i
				return true
			end
		end
	end

	return false
end

function LayeredEntityManager:prot_delete(entityId)
	EntityManager.prot_delete(self, entityId)
	local layerIdx = self.eIdToLayer[entityId]
	assert(layerIdx, "Entity Id not found in LayeredEntityManager")
	local layer = self.layers[layerIdx]
    for i=1, #layer do
        if layer[i].id == entityId then
            table.remove(layer, i)
            break
        end
    end
end

function LayeredEntityManager:addLayer(name, position)
	local layers = self.layers
	position = position or (#layers + 1)
	layers[position] = EntityLayer:new(name)
end

function LayeredEntityManager:removeLayer(position)
	local layers = self.layers
	if layers[position] then
		table.remove(layers, position)
	end
end

function LayeredEntityManager:removeLayerByName(name)
	local layers = self.layers
	for i = 1, #layers do
		if layers[i].name == name then
			table.remove(layers, i)
		end
	end
end

return LayeredEntityManager