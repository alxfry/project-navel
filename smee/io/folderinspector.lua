local format = string.format
local printf = function(...) return dbgprint(format(...)) end
local InspectTypeEnum = 
{  
    FULL_PATH = 1,
    FILENAME = 2,
    FILENAME_EXT = 3,
}

local function trim(s)
    s = string.gsub(s, '^%s+', '') -- strip preceding whitespace
    s = string.gsub(s, '%s+$', '') -- strip trailing whitespace
    return s
end

local function capture(command)
    local f = assert(io.popen(command, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    return trim(s)
end

local uniqueNames = {}

local function escapeMagicCharacters(string)
    local escapedString = string
    escapedString = string.gsub(escapedString, "%(", "%%%(")
    escapedString = string.gsub(escapedString, "%)", "%%%)")
    escapedString = string.gsub(escapedString, "%%", "%%%%")
    escapedString = string.gsub(escapedString, "%+", "%%%+")
    escapedString = string.gsub(escapedString, "%-", "%%%-")
    escapedString = string.gsub(escapedString, "%*", "%%%*")
    escapedString = string.gsub(escapedString, "%?", "%%%?")
    escapedString = string.gsub(escapedString, "%[", "%%%[")
    escapedString = string.gsub(escapedString, "%^", "%%%^")
    escapedString = string.gsub(escapedString, "%$", "%%%$")
    return escapedString
end


local function inspect(inspectType, ...)
    inspectType = inspectType or InspectTypeEnum.FULL_PATH
    local dir = (...) or capture('cd')
    -- pattern to split of the path from a file entry on dir /b
    local dirPattern = "^(.-)([^\\]-([^\\%.]+))\n"
    -- do the dir command
    local listing = capture(format('DIR /B "%s"', dir)) .. '\n'
    -- gets the absolute path of the first file, is identical if dir is not relative
    local fullDir = string.match(listing, dirPattern)
    local pattern = fullDir .. "([%S_]+)%.([%S_]+)\n"
    local result = ""
    if inspectType == InspectTypeEnum.FULL_PATH then
        for name, extension in string.gmatch(listing, pattern) do
            result = result..fullDir.."\\"..name.."."..extension.."\n"
        end
    elseif inspectType == InspectTypeEnum.FILENAME_EXT then
        for name, extension in string.gmatch(listing, pattern) do
            result = result..name.."."..extension.."\n"
        end
    elseif inspectType == InspectTypeEnum.FILENAME then
        for name, extension in string.gmatch(listing, pattern) do
            result = result..name.."\n"
        end
    end
    return result
end

local function inspectList(inspectType, ...)
    inspectType = inspectType or InspectTypeEnum.FULL_PATH
    local dir = (...) or capture('cd')
    -- dbgprint(capture('dir ' .. (...)))
    local dirPattern = "^(.-)([^\\]-([^\\%.]+))\n"
    local listing = capture(format('DIR /S /B "%s"', dir)) .. '\n'
    -- gets the absolute path of the first file, is identical if dir is not relative
    local fullDir = string.match(listing, dirPattern)
    local escapedFullDir = escapeMagicCharacters(fullDir)
    local pattern = escapedFullDir .. "([%S_]+)%.([%S_]+)\n"
    local result = {}
    if inspectType == InspectTypeEnum.FULL_PATH then
        for name, extension in string.gmatch(listing, pattern) do
            table.insert(result, fullDir..name.."."..extension)
        end
    elseif inspectType == InspectTypeEnum.FILENAME_EXT then
        for name, extension in string.gmatch(listing, pattern) do
            table.insert(result, name.."."..extension)
        end
    elseif inspectType == InspectTypeEnum.FILENAME then
        for name, extension in string.gmatch(listing, pattern) do
            table.insert(result, name)
        end
    end
    return result
end

return { inspect = inspect, inspectList = inspectList, InspectTypeEnum = InspectTypeEnum }