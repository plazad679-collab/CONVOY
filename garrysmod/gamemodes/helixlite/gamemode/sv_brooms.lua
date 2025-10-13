--[[
    Gestión de escobas.
]]

HLX.Brooms = HLX.Brooms or {}
local brooms = HLX.Brooms

brooms.RestrictedZones = {
    library = true
}

function brooms.CanUse(ply)
    local faction = ply:GetNWString("hlx_faction", "students")
    if HLX.Zones.IsPositionSafe(ply:GetPos()) then
        return false, "Zona segura"
    end
    return true
end

function brooms.Toggle(ply, state)
    local can, reason = brooms.CanUse(ply)
    if not can then
        ply:ChatPrint("No puedes usar la escoba: " .. (reason or ""))
        return
    end
    ply:SetNWBool("hlx_on_broom", state)
    HLX.Hooks.Run("HLX:BroomMounted", ply, state)
end

net.Receive("hlx_brooms", function(len, ply)
    local state = net.ReadBool()
    brooms.Toggle(ply, state)
end)

return brooms
