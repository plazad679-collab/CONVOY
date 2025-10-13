--[[
    HUD personalizado con barra de maná.
]]

HLX.HUD = HLX.HUD or {}

hook.Add("HUDPaint", "HLX.DrawHUD", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    local health = ply:Health()
    local armor = ply:Armor()
    local mana = ply:GetNWInt("hlx_mana", HLX.Config.ManaBase)
    local maxMana = HLX.Config.ManaBase
    local money = ply:GetNWInt("hlx_money", 0)
    local maxHealth = math.max(ply:GetMaxHealth(), 1)

    local baseX, baseY = 30, ScrH() - 120

    draw.RoundedBox(6, baseX, baseY, 220, 24, Color(50, 20, 20, 200))
    draw.RoundedBox(6, baseX, baseY, math.Clamp(health / maxHealth, 0, 1) * 220, 24, Color(200, 60, 60, 220))
    draw.SimpleText(HLX.Translate("hud_health") .. ": " .. health, "HLX_Text", baseX + 10, baseY + 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    draw.RoundedBox(6, baseX, baseY + 30, 220, 24, Color(20, 50, 80, 200))
    draw.RoundedBox(6, baseX, baseY + 30, math.Clamp(armor / 100, 0, 1) * 220, 24, Color(70, 120, 200, 220))
    draw.SimpleText(HLX.Translate("hud_armor") .. ": " .. armor, "HLX_Text", baseX + 10, baseY + 42, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    draw.RoundedBox(6, baseX, baseY + 60, 220, 24, Color(20, 20, 60, 200))
    draw.RoundedBox(6, baseX, baseY + 60, math.Clamp(mana / maxMana, 0, 1) * 220, 24, Color(120, 80, 255, 220))
    draw.SimpleText(HLX.Translate("hud_mana") .. ": " .. mana, "HLX_Text", baseX + 10, baseY + 72, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    draw.SimpleText(HLX.Translate("hud_money") .. ": " .. HLX.Util.FormatMoney(money), "HLX_Text", baseX, baseY - 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end)

hook.Add("HUDShouldDraw", "HLX.HideDefaultHUD", function(name)
    if name == "CHudHealth" or name == "CHudBattery" then return false end
end)
