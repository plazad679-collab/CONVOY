local Houses = Package.Require("Shared/Data/Houses.lua")
local Spells = Package.Require("Shared/Data/Spells.lua")
local Classes = Package.Require("Shared/Data/Classes.lua")
local Locations = Package.Require("Shared/Data/Locations.lua")

local LoreService = {}

function LoreService:get_houses()
    return Houses
end

function LoreService:get_spells()
    return Spells
end

function LoreService:get_classes()
    return Classes
end

function LoreService:get_locations()
    return Locations
end

return LoreService
