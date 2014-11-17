local function location(level)
    local dbginfo = debug.getinfo(level + 1, "Sl")

    local location = dbginfo.short_src
    location = location and location:sub((location:find("/script/") or -38) + 8) or "(?)"
    location = location .. ":" .. (dbginfo.currentline or -1)
    local padding = 30 - #location
    if padding > 0 then
        location = location .. (" "):rep(padding)
    else
        location = location .. "\t"
    end
    return location
end

-- DbgPrint is nil in protected retail versions, but thats ok, as dbgprint is not called
function dbgprint(...)
    local buf = {...}
    for i=1, select("#", ...) do
        buf[i] = tostring(buf[i])
    end
    print(location(2), unpack(buf))
end

local function changeLuaLoader(loader)
    table.insert(package.loaders, 2, loader)
end

return { changeLuaLoader = changeLuaLoader }