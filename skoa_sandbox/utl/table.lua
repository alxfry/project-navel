local Table = {}

function Table.dump(tableToDump, depth)
    if type(tableToDump) ~= "table" then
        return tostring(tableToDump)
    end

    depth = depth or 10

    local members = {}
    local dump = "{ "
    for k, v in pairs(tableToDump) do
        local member = "[" .. tostring(k) .. "] = "

        if type(v) == "table" and depth > 0 then
            member = member .. Table.dump(v, depth - 1)
        else
            member = member .. tostring(v)
        end
        table.insert(members, member)
    end

    dump = dump .. table.concat(members, ", ") .. " }"
    
    return dump
end

return Table
