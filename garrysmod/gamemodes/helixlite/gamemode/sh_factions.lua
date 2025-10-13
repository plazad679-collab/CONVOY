--[[
    Definiciones compartidas de facciones.
]]

HLX.Factions = HLX.Factions or {}
HLX.Factions.Stored = HLX.Factions.Stored or {}

function HLX.Factions.Register(id, data)
    id = string.lower(id)
    data.id = id
    HLX.Factions.Stored[id] = data
end

function HLX.Factions.Get(id)
    return HLX.Factions.Stored[string.lower(id or "")]
end

return HLX.Factions
