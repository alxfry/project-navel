local Class = require "shared.middleclass"

local Vector2 = Class "Vector2"

function Vector2:initialize(x, y)
	self.x = x
	self.y = y
end

Vector2.__add = function(t, o)
	return Vector2.add(t, o)
end

Vector2.__mul = function(t, o)
	if type(t) == "number" then
		t, o = o, t
	end
	if type(o) == "number" then
		return Vector2:new(o * t.x, o * t.y)
	elseif type(o) == "table" then
		return Vector2.dot(t, o)
	end
end

Vector2.__div = function(t, o)
    if type(t) == "number" then
        t, o = o, t
    end
    if type(o) == "number" then
        return Vector2:new(t.x / o, t.y / o)
    elseif type(o) == "table" then
        assert(false, "no division defined on vectors")
    end
end

Vector2.__sub = function(t, o)
	return Vector2.add(t, -1 * o)
end

Vector2.__unm = function(t)
	return -1 * t
end

Vector2.__tostring = function(t)
    return "(" .. t.x .. "," .. t.y .. ")"
end

function Vector2.sqLength(v)
	return v.x * v.x + v.y * v.y
end

function Vector2.length(v)
	return math.sqrt(Vector2.sqLength(v))
end

function Vector2.normalize(v)
    local length = Vector2.length(v)
    v.x = length == 0 and 0 or v.x/length
    v.y = length == 0 and 0 or v.y/length
end

function Vector2.add(v1, v2, result)
	if result then
		result.x = v1.x + v2.x
		result.y = v1.y + v2.y
	else
		return Vector2:new(v1.x + v2.x, v1.y + v2.y)
	end
end

function Vector2.dot(v1, v2)
	return v1.x * v2.x + v1.y * v2.y
end

local Vector3 = {}

local vector3Ops =
{
	__index = function(t, k)
		if k == "x" then
			return t[1]
		elseif k == "y" then
			return t[2]
		elseif k == "z" then
			return t[3]
		end
	end,

	__add = function(t, o)
		return Vector3.add(t, o)
	end,

	__mul = function(t, o)
		if type(t) == "number" then
			t, o = o, t
		end
		if type(o) == "number" then
			return Vector3.new(o * t.x, o * t.y, o * t.z)
		elseif type(o) == "table" then
			return Vector3.dot(t, o)
		end
	end,

    __div = function(t, o)
        if type(t) == "number" then
            t, o = o, t
        end
        if type(o) == "number" then
            return Vector3.new(t.x / o, t.y / o, t.z / o)
        elseif type(o) == "table" then
            assert(false, "no division defined on vectors")
        end
    end,

	__sub = function(t, o)
		return Vector3.add(t, -1 * o)
	end,

	__unm = function(t)
		return -1 * t
	end
}
function Vector3.new(x, y, z)
	local v = { x, y, z }
	setmetatable(v, vector3Ops)
	return v
end

function Vector3.sqLength(v)
	return v.x * v.x + v.y * v.y + v.z * v.z
end

function Vector3.length(v)
	return math.sqrt(Vector3.sqLength(v))
end

function Vector3.add(v1, v2, result)
	if result then
		result.x = v1.x + v2.x
		result.y = v1.y + v2.y
		result.z = v1.z + v2.z
	else
		return Vector3.new(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
	end
end

function Vector3.dot(v1, v2)
	return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

local OBB2D = {}
OBB2D.__index = OBB2D

function OBB2D.new(x, y, width, height, rotAngle)
    local obb = {}
    local center = Vector2:new(x, y)
    local xDir = Vector2:new(math.cos(rotAngle), math.sin(rotAngle))
    local yDir = Vector2:new(-math.sin(rotAngle), math.cos(rotAngle))

    xDir = xDir * (width/2)
    yDir = yDir * (height/2)

    -- The 4 corners of the bounding box (starting at lower left)
    obb.corners = {n=4}
    obb.corners[1] = center - xDir - yDir
    obb.corners[2] = center + xDir - yDir
    obb.corners[3] = center + xDir + yDir
    obb.corners[4] = center - xDir + yDir

    -- the axes made from the edges leading away from corner[1]
    obb.axes = {n=2}
    obb.axes[1] = obb.corners[2] - obb.corners[1]
    obb.axes[2] = obb.corners[4] - obb.corners[1]
    obb.axes[1] = obb.axes[1] / Vector2.sqLength(obb.axes[1])
    obb.axes[2] = obb.axes[2] / Vector2.sqLength(obb.axes[2])

    -- compute the origin of the box in local coordinate system
    obb.origin = {n=2}
    obb.origin[1] = Vector2.dot(obb.corners[1], obb.axes[1])
    obb.origin[2] = Vector2.dot(obb.corners[1], obb.axes[2])
    setmetatable(obb, OBB2D)
    return obb
end

function OBB2D.oneWayOverlap(obb1, obb2)
    for i = 1, 2 do
        local cornerProj = Vector2.dot(obb2.corners[1], obb1.axes[i])
        -- Find the extent of box 2 on axis i
        local projMin = cornerProj
        local projMax = cornerProj

        for j = 2, 4 do
            cornerProj = Vector2.dot(obb2.corners[j], obb1.axes[i])

            if cornerProj < projMin then
                projMin = cornerProj
            elseif cornerProj > projMax then
                projMax = cornerProj
            end
        end
        -- We have to subtract off the origin

        -- See if [projMin, projMax] intersects [0, 1]
        if (projMin > 1 + obb1.origin[i]) or (projMax < obb1.origin[i]) then
            -- There was no intersection along this dimension;
            -- the boxes cannot possibly overlap.
            return false
        end
    end
    -- There was no dimension along which there is no intersection.
    -- Therefore the boxes overlap.
    return true
end

function OBB2D.checkCollision(obb1, obb2)
    return OBB2D.oneWayOverlap(obb1, obb2) and OBB2D.oneWayOverlap(obb1, obb2)
end

return { Vector2 = Vector2, Vector3 = Vector3, OBB2D = OBB2D }
