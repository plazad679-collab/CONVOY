--[[
    Definición de zonas y reglas compartidas.
]]

HLX = HLX or {}
HLX.Zones = HLX.Zones or {}

local zones = HLX.Zones
zones.List = zones.List or {}

function zones.Register(id, data)
    id = string.lower(id)
    data.id = id
    zones.List[id] = data
end

function zones.Get(id)
    return zones.List[string.lower(id or "")]
end

function zones.IsPositionSafe(pos)
    for _, data in pairs(zones.List) do
        local min = data.mins
        local max = data.maxs
        if min and max and pos:WithinAABox(min, max) then
            return data.safe or false
        end
    end
    return false
end

function zones.InitializeDefaults()
    if zones._initialized then return end
    zones._initialized = true

    zones.Register("library", {
        name = "Biblioteca",
        safe = true,
        blocked_spells = { "expelliarmus", "stupefy" },
        mins = Vector(-500, -500, 0),
        maxs = Vector(500, 500, 300)
    })
end

return zones
