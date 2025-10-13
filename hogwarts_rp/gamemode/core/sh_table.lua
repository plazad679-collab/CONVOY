local TableUtils = {}

function TableUtils.DeepCopy(value)
    if type(value) ~= "table" then return value end
    local copy = {}
    for key, inner in pairs(value) do
        copy[key] = TableUtils.DeepCopy(inner)
    end
    return copy
end

function TableUtils.Merge(original, updates)
    local result = TableUtils.DeepCopy(original)
    for key, value in pairs(updates or {}) do
        if type(value) == "table" and type(result[key]) == "table" then
            result[key] = TableUtils.Merge(result[key], value)
        else
            result[key] = value
        end
    end
    return result
end

function TableUtils.IndexBy(list, key)
    local indexed = {}
    for _, item in ipairs(list) do
        indexed[item[key]] = item
    end
    return indexed
end

Hogwarts.Core.TableUtils = TableUtils

return TableUtils
