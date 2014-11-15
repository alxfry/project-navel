local Class = require "shared.middleclass"

local Behavior = Class "Behavior"

STATUS = {
	INVALID = 1,
	SUCCESS = 2,
	FAILURE = 3,
	RUNNING = 4,
}

Behavior.static.STATUS = STATUS

function Behavior:initialize()
	self.status = STATUS.INVALID
end

function Behavior:tick()
	self.status = self:update()

	if self.status ~= STATUS.RUNNING then
		self:onTerminate(self.status)
	end

	return self.status
end

function Behavior:update()

end

function Behavior:getStatus()
	return self.status
end

function Behavior:reset()
	self.status = STATUS.INVALID
end

function Behavior:isTerminated()
	return (self.status == STATUS.SUCCESS) or (self.status == STATUS.FAILURE)
end

function Behavior:isRunning()
	return self.status == STATUS.RUNNING
end

function Behavior:onTerminate()
end


local TEST_BEHAVIOR = Class("TEST_BEHAVIOR", Behavior)

function TEST_BEHAVIOR:initialize()
	Behavior.initialize(self)
	-- self.initCalled = 1
	self.status = STATUS.RUNNING
	self.updateCalled = 0
	self.onTerminateCalled = 0
end

function TEST_BEHAVIOR:onTerminate()
	self.onTerminateCalled = self.onTerminateCalled + 1
end

function TEST_BEHAVIOR:update()
	self.updateCalled = self.updateCalled + 1 
	return self.status
end

local TEST_INSTANCE = TEST_BEHAVIOR:new()
assert(TEST_INSTANCE.updateCalled == 0, "Test failed")
TEST_INSTANCE:tick()
assert(TEST_INSTANCE.updateCalled == 1, "Test failed")
assert(TEST_INSTANCE.onTerminateCalled == 0, "Test failed")
TEST_INSTANCE.status = STATUS.SUCCESS
TEST_INSTANCE:tick()
assert(TEST_INSTANCE.onTerminateCalled == 1, "Test failed")


local Composite = Class("Composite", Behavior)

function Composite:initialize()
	Behavior.initialize(self)
	self.children = {}
end

function Composite:child(idx)
	return self.children[idx]
end

function Composite:addChild(childNode)
	local children = self.children
	children[#children + 1] = childNode
end

function Composite:removeChild(childNode)
	for i = 1, #self.children do
		if self.children[i] == childNode then
			table.remove(self.children, i)
		end
	end
end

function Composite:clearChildren()
	self.children = {}
end

local TEST_COMPOSITE = Class("TEST_COMPOSITE", Composite)

TEST_INSTANCE = TEST_COMPOSITE:new()
assert(#TEST_INSTANCE.children == 0, "Test failed")
TEST_INSTANCE:addChild("test")
assert(#TEST_INSTANCE.children == 1, "Test failed")
assert(TEST_INSTANCE:child(1) == "test", "Test failed")
TEST_INSTANCE:addChild("test2")
TEST_INSTANCE:addChild("test3")
TEST_INSTANCE:removeChild("test2")
assert(#TEST_INSTANCE.children == 2 and 
	TEST_INSTANCE:child(1) == "test" and 
	TEST_INSTANCE:child(2) == "test3", "Test failed")


local Sequence = Class("Sequence", Composite)

function Sequence:initialize()
	Composite.initialize(self)
end

function Sequence:update()
	for i = 1, #self.children do
		local current = self.children[i]

		local status = current:tick()

		-- IF CHILD NO SUCCESS -> SEQUENCE NO SUCCESS
		if not (status == STATUS.SUCCESS) then
			print(status)
			return status
		end
	end
	-- ALL CHILDREN SUCCESSFUL -> SUCCESS!
	return STATUS.SUCCESS
end


local TEST_SEQUENCE = Class("TEST_SEQUENCE", Sequence)

function TEST_SEQUENCE:initialize(numChildren)
	Sequence.initialize(self)
	for i = 1, numChildren do
		table.insert(self.children, TEST_BEHAVIOR:new())
	end
end

local CHILD_VAR
TEST_INSTANCE = TEST_SEQUENCE:new(2)
assert(TEST_INSTANCE:tick() == STATUS.RUNNING, "Test failed")
assert(TEST_INSTANCE:child(1).onTerminateCalled == 0, "Test failed")
CHILD_VAR = TEST_INSTANCE:child(1)
CHILD_VAR.status = STATUS.FAILURE
assert(TEST_INSTANCE:tick() == STATUS.FAILURE, "Test failed")
assert(TEST_INSTANCE:child(1).onTerminateCalled == 1, "Test failed")
assert(TEST_INSTANCE:child(2).onTerminateCalled == 0, "Test failed")

TEST_INSTANCE = TEST_SEQUENCE:new(2)
assert(TEST_INSTANCE:tick() == STATUS.RUNNING, "Test failed")
assert(TEST_INSTANCE:child(1).onTerminateCalled == 0, "Test failed")
CHILD_VAR = TEST_INSTANCE:child(1)
CHILD_VAR.status = STATUS.SUCCESS
assert(TEST_INSTANCE:tick() == STATUS.RUNNING, "Test failed")
assert(TEST_INSTANCE:child(1).onTerminateCalled == 1, "Test failed")

local STATUS_TBL = { STATUS.SUCCESS, STATUS.FAILURE }
for i = 1, 2 do
	TEST_INSTANCE = TEST_SEQUENCE:new(1)
	assert(TEST_INSTANCE:tick() == STATUS.RUNNING, "Test failed")
	assert(TEST_INSTANCE:child(1).onTerminateCalled == 0, "Test failed")
	CHILD_VAR = TEST_INSTANCE:child(1)
	CHILD_VAR.status = STATUS_TBL[i]
	assert(TEST_INSTANCE:tick() == STATUS_TBL[i], "Test failed")
	assert(TEST_INSTANCE:child(1).onTerminateCalled == 1, "Test failed")
end


local Selector = Class("Selector", Composite) 

function Selector:initialize()
	Composite.initialize(self)
end

function Selector:update()
	for i = 1, #self.children do
		local current = self.children[i]

		local status = current:tick()

		-- IF CHILD NO FAILURE -> SEQUENCE NO FAILURE
		if not (status == STATUS.FAILURE) then
			return status
		end
	end
	-- ALL CHILDREN FAILURE -> FAILURE!
	return STATUS.FAILURE
end

local TEST_SELECTOR = Class("TEST_SELECTOR", Selector)

function TEST_SELECTOR:initialize(numChildren)
	Sequence.initialize(self)
	for i = 1, numChildren do
		table.insert(self.children, TEST_BEHAVIOR:new())
	end
end

local CHILD_VAR
TEST_INSTANCE = TEST_SELECTOR:new(2)
assert(TEST_INSTANCE:tick() == STATUS.RUNNING, "Test failed")
assert(TEST_INSTANCE:child(1).onTerminateCalled == 0, "Test failed")
CHILD_VAR = TEST_INSTANCE:child(1)
CHILD_VAR.status = STATUS.FAILURE
assert(TEST_INSTANCE:tick() == STATUS.RUNNING, "Test failed")
assert(TEST_INSTANCE:child(1).onTerminateCalled == 1, "Test failed")

TEST_INSTANCE = TEST_SELECTOR:new(2)
assert(TEST_INSTANCE:tick() == STATUS.RUNNING, "Test failed")
assert(TEST_INSTANCE:child(1).onTerminateCalled == 0, "Test failed")
CHILD_VAR = TEST_INSTANCE:child(1)
CHILD_VAR.status = STATUS.SUCCESS
assert(TEST_INSTANCE:tick() == STATUS.SUCCESS, "Test failed")
assert(TEST_INSTANCE:child(1).onTerminateCalled == 1, "Test failed")

local STATUS_TBL = { STATUS.SUCCESS, STATUS.FAILURE }
for i = 1, 2 do
	TEST_INSTANCE = TEST_SELECTOR:new(1)
	assert(TEST_INSTANCE:tick() == STATUS.RUNNING, "Test failed")
	assert(TEST_INSTANCE:child(1).onTerminateCalled == 0, "Test failed")
	CHILD_VAR = TEST_INSTANCE:child(1)
	CHILD_VAR.status = STATUS_TBL[i]
	assert(TEST_INSTANCE:tick() == STATUS_TBL[i], "Test failed")
	assert(TEST_INSTANCE:child(1).onTerminateCalled == 1, "Test failed")
end