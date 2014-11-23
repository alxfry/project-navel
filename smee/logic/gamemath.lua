local Class = require "smee.libs.middleclass"

local EMPTY_TABLE
----------------------------------------------------------------------

local function clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

----------------------------------------------------------------------

local Vector2 = Class "Vector2"

Vector2.static.Zero = Vector2:new(0,0)


-- An intersection implementation for vector segments that makes use of Cramers Law
function Vector2.static.intersects(v0, v, w0, w)
    -- IDEA:
    -- Searching for a solution for v0 + t*v == w0 + u*w (with t and u in [0,1] in this case)
    -- Therefore we get Matrix (A | b):  t*v - u*w = w0 - v0  

    -- CREATING VECTOR SEGMENTS
    local vSeg = v - v0
    local wSeg = w - w0
    -- NOTE: This is the determinant of the matrix that would represent ( vSeg wSeg | v0-w0 )
    -- Solving this matrix would give us the intersection point; but let's do a faster approach
    local determinant = vSeg.x * wSeg.y - vSeg.y * wSeg.x

    -- NO SOLUTION: If the determinant is zero there are no solutions to the matrix described earlier.
    -- (i.e. the vectors are parallel)
    if determinant == 0 then
        return false
    end

    -- THE RIGHT SIDE OF THE MATRIX
    local b = w0 - v0
    -- USE CRAMERS LAW
    local t = (b.x * vSeg.y - b.y * vSeg.x) / determinant
    if (t < 0 or t > 1) then
        -- No intersection was found within the boundaries of vSeg
        return false
    end

    local u = (b.x * wSeg.y - b.y * wSeg.x) / determinant
    if (u < 0 or u > 1) then
        -- No intersection was found within the boundaries of wSeg
        return false
    end

    return true, v0 + t * vSeg
end


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

function Vector2.copy(v)
    return Vector2:new(v.x, v.y)
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

function Vector2.distance(v1, v2)
    return Vector2.length(v1 - v2)
end

function Vector2.isNull(v)
    return v.x == 0 and v.y == 0
end

----------------------------------------------------------------------

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

----------------------------------------------------------------------

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

----------------------------------------------------------------------

local AABB = Class "AABB"
-- TODO make Transform Class, Use Vector2 Class
function AABB:initialize(cX, cY, width, height)
    self.pos = Vector2:new(cX, cY)
    self.width = width
    self.height = height
    self.minVec = Vector2:new(self.pos.x - width/2, self.pos.y - height/2)
    --self.minX = self.pos - width/2
    --self.maxX = self.pos + width/2
    --self.minY = self.pos - height/2
    --self.maxY = self.pos + height/2
end

function AABB:checkCollision(otherAABB, myTransform, otherTransform)
    myTransform = myTransform or Vector2.Zero
    otherTransform = otherTransform or Vector2.Zero
    local myWorldMin = self.minVec + myTransform
    local width, height = self.width, self.height 
    --local myWorldMax = self.minVec
    local otherWorldMin = otherAABB.minVec + otherTransform
    --local myPos = self.pos
    --local otherPos = otherAABB.pos
    --local myMinX = self.minX + (myTransform.x or 0) -- use empty transform instead
    --local myMinY = self.minY + (myTransform.y or 0)
    --local myMaxX = self.maxX + (myTransform.x or 0)
    --local myMaxY = self.maxY + (myTransform.y or 0)
    --local otherMinX = otherPos.x + (otherTransform.x or 0)
    --local otherMinY = otherPos.y + (otherTransform.y or 0)
    --local otherMaxX = otherMinX + otherAABB.width
    --local otherMaxY = otherMinY + otherAABB.height
    local oWidth, oHeight = otherAABB.width, otherAABB.height
    local xOverlap =    (otherWorldMin.x > myWorldMin.x and otherWorldMin.x < myWorldMin.x + width) 
                     or (otherWorldMin.x + oWidth > myWorldMin.x and otherWorldMin.x + oWidth < myWorldMin.x + width)
    local yOverlap =    (otherWorldMin.y > myWorldMin.y and otherWorldMin.y < myWorldMin.y + height) 
                     or (otherWorldMin.y + oHeight > myWorldMin.y and otherWorldMin.y + oHeight < myWorldMin.y + height)
    return yOverlap and xOverlap 
end

function AABB:getApproachPos(myTransform, approachVector)

end

return {
    clamp = clamp,
    Vector2 = Vector2,
    Vector3 = Vector3,
    OBB2D = OBB2D,
}
