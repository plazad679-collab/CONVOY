--[[
    Registro de facciones y roles especiales.
]]

HLX.Factions = HLX.Factions or {}
local factions = HLX.Factions

function factions.InitializeDefaults()
    if factions._initialized then return end
    factions._initialized = true

    factions.Register("students", {
        name = "Students",
        color = Color(120, 180, 255),
        default = true,
        permissions = { "hlx.basic", "hlx.learn" }
    })
end

function factions.Apply(ply, factionID)
    local data = factions.Get(factionID)
    if not data then return false end
    ply:SetNWString("hlx_faction", factionID)
    if data.permissions then
        ply:SetNWString("hlx_role", factionID)
    end
    HLX.DB.Query(string.format("UPDATE hlx_characters SET faction = '%s' WHERE id = %d", HLX.DB.Escape(factionID), tonumber(ply.CurrentCharacter and ply.CurrentCharacter.id) or 0))
    return true
end

return factions
