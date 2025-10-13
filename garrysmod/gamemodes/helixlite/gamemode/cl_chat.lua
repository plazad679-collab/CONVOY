--[[
    Chat mágico con colores.
]]

hook.Add("OnPlayerChat", "HLX.ChatColors", function(ply, text, teamChat, isDead)
    if not IsValid(ply) then return end
    local faction = ply:GetNWString("hlx_faction", "students")
    local color = HLX.Util.GetFactionColor(faction)
    chat.AddText(color, string.format("[%s] ", string.upper(faction)), color_white, ply:Nick(), color, ": " .. text)
    return true
end)
