local TableUtils = {}

function TableUtils.deep_copy(original)
    if type(original) ~= "table" then
        return original
    end

    local copy = {}
    for key, value in pairs(original) do
        copy[key] = TableUtils.deep_copy(value)
    end
    return copy
end

function TableUtils.merge(destination, source)
    for key, value in pairs(source) do
        if type(value) == "table" then
            destination[key] = destination[key] or {}
            TableUtils.merge(destination[key], value)
        else
            destination[key] = value
        end
    end
    return destination
end

function TableUtils.find(list, predicate)
    for index, value in ipairs(list) do
        if predicate(value, index) then
            return value, index
        end
    end
end

function TableUtils.index_by(list, key)
    local result = {}
    for _, value in ipairs(list) do
        result[value[key]] = value
    end
    return result
end

return TableUtils
