local Utils = {}

function Utils.deepcopy(tbl)
    if type(tbl) ~= "table" then return tbl end
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = Utils.deepcopy(v)
    end
    return copy
end

function Utils.merge(base, extra)
    local result = Utils.deepcopy(base)
    for k, v in pairs(extra or {}) do
        if type(v) == "table" and type(result[k]) == "table" then
            result[k] = Utils.merge(result[k], v)
        else
            result[k] = v
        end
    end
    return result
end

function Utils.find(tbl, predicate)
    for key, value in pairs(tbl) do
        if predicate(value, key) then
            return value, key
        end
    end
    return nil
end

function Utils.table_count(tbl)
    local count = 0
    for _ in pairs(tbl or {}) do
        count = count + 1
    end
    return count
end

function Utils.uuid()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and math.random(0, 15) or math.random(8, 11)
        return string.format("%x", v)
    end)
end

return Utils
