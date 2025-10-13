--[[
    Visualización de afinidad de varitas.
]]

HLX.ClientWands = HLX.ClientWands or {}
local cwands = HLX.ClientWands

function cwands.DrawInfo()
    local ply = LocalPlayer()
    local wandID = ply:GetNWString("hlx_wand", "basic_wand")
    local wand = HLX.Magic.GetWand(wandID)
    if not wand then return end
    draw.SimpleText(string.format("Varita: %s (%s/%s)", wand.name or wandID, wand.wood or "?", wand.core or "?"), "HLX_Text", ScrW() - 20, ScrH() - 40, Color(220, 200, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
end

hook.Add("HUDPaint", "HLX.DrawWandInfo", cwands.DrawInfo)

return cwands
