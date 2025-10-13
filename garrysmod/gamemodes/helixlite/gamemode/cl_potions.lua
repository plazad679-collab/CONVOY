--[[
    Interfaz sencilla para pociones.
]]

HLX.ClientPotions = HLX.ClientPotions or {}
local cp = HLX.ClientPotions

function cp.OpenBrewMenu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(240, 180)
    frame:Center()
    frame:SetTitle("Mesa de pociones")
    frame:MakePopup()
    frame.Paint = HLX.Derma.PaintPanel

    local list = frame:Add("DComboBox")
    list:Dock(TOP)
    list:DockMargin(10, 10, 10, 10)
    list:SetValue("Selecciona receta")

    for id, data in pairs(HLX.Potions.Recipes or {}) do
        list:AddChoice(data.result or id, id)
    end

    local brew = frame:Add("DButton")
    brew:Dock(BOTTOM)
    brew:DockMargin(10, 10, 10, 10)
    brew:SetText("Preparar")
    brew.Paint = HLX.Derma.PaintButton

    brew.DoClick = function()
        local _, id = list:GetSelected()
        if not id then return end
        net.Start("hlx_potions")
        net.WriteString(id)
        net.SendToServer()
        frame:Close()
    end
end

concommand.Add("hlx_potions", cp.OpenBrewMenu)
