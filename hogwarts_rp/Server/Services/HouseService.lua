local Logger = Package.Require("Shared/Modules/Logger.lua")
local Houses = Package.Require("Shared/Data/Houses.lua")
local TableUtils = Package.Require("Shared/Modules/TableUtils.lua")

local HouseService = {}
HouseService.houses = Houses

function HouseService:get(id)
    return self.houses[id]
end

function HouseService:list()
    local list = {}
    for id, data in pairs(self.houses) do
        list[#list + 1] = TableUtils.merge({ id = id }, data)
    end
    return list
end

function HouseService:assign_by_traits(traits)
    local best_house
    local best_score = -math.huge

    for id, data in pairs(self.houses) do
        local score = 0
        for _, trait in ipairs(data.traits) do
            for _, desired in ipairs(traits or {}) do
                if trait == desired then
                    score = score + 1
                end
            end
        end

        if score > best_score then
            best_house = id
            best_score = score
        end
    end

    if not best_house then
        best_house = "SortingPending"
    end

    Logger:debug("Sombrero seleccionador sugiere %s con score %d", best_house, best_score)
    return best_house
end

return HouseService
