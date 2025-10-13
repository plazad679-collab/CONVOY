--[[
    Gestión de varitas.
]]

HLX.Wands = HLX.Wands or {}
local wands = HLX.Wands

function wands.Assign(ply, wandID)
    local wand = HLX.Magic.GetWand(wandID)
    if not wand then return false end
    ply:SetNWString("hlx_wand", wandID)
    if ply.CurrentCharacter then
        HLX.DB.Query(string.format("UPDATE hlx_characters SET wand_id = '%s' WHERE id = %d", HLX.DB.Escape(wandID), tonumber(ply.CurrentCharacter.id) or 0))
    end
    HLX.Hooks.Run("HLX:WandAssigned", ply, wandID)
    return true
end

function wands.GetAffinity(ply, school)
    local wandID = ply:GetNWString("hlx_wand", "basic_wand")
    local wand = HLX.Magic.GetWand(wandID)
    local affinity = 0
    if wand and wand.affinities then
        affinity = wand.affinities[school] or 0
    end
    return affinity
end

return wands
