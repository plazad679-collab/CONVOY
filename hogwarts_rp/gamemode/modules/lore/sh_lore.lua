local Lore = {}

function Lore:GetHouses()
    return Hogwarts.Data.Houses
end

function Lore:GetSpells()
    return Hogwarts.Data.Spells
end

function Lore:GetClasses()
    return Hogwarts.Data.Classes
end

function Lore:GetLocations()
    return Hogwarts.Data.Locations
end

Hogwarts.Modules.Lore = Lore

return Lore
