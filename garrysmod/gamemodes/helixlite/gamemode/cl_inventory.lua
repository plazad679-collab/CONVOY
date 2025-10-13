--[[
    Interfaz de inventario drag&drop simple.
]]

HLX.Inventory = HLX.Inventory or {}
local inventory = HLX.Inventory

inventory.Items = inventory.Items or {}
inventory.Frame = nil

function inventory.Initialize()
    net.Receive("hlx_inventory", function()
        local count = net.ReadUInt(12)
        inventory.Items = {}
        for i = 1, count do
            local id = net.ReadString()
            local qty = net.ReadUInt(16)
            inventory.Items[id] = qty
        end
        if inventory.Frame and inventory.Frame:IsVisible() then
            inventory.BuildList()
        end
    end)

    net.Receive("hlx_ui", function()
        local action = net.ReadString()
        if action == "inventory_toggle" then
            inventory.Toggle()
        elseif action == "lorepack_load" then
            local id = net.ReadString()
            if HLX.Lorepacks and HLX.Lorepacks.LoadClient then
                HLX.Lorepacks.LoadClient(id)
            end
        elseif action == "lorepack_unload" then
            HLX.Magic.InitializeDefaults()
            if HLX.CharacterCreator then
                HLX.CharacterCreator.Houses = { students = { name = "Students" } }
                HLX.CharacterCreator.Initialize()
            end
        end
    end)
end

function inventory.BuildList()
    if not IsValid(inventory.Frame) or not IsValid(inventory.Scroll) then return end
    inventory.Scroll:Clear()
    for itemID, qty in pairs(inventory.Items) do
        local panel = inventory.Scroll:Add("DPanel")
        panel:SetTall(40)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 8)
        panel.Paint = function(self, w, h)
            HLX.Derma.PaintPanel(self, w, h)
            draw.SimpleText(itemID .. " x" .. qty, "HLX_Text", 10, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end

function inventory.Toggle()
    if IsValid(inventory.Frame) then
        inventory.Frame:SetVisible(not inventory.Frame:IsVisible())
        if inventory.Frame:IsVisible() then
            inventory.BuildList()
        end
        return
    end

    inventory.Frame = vgui.Create("DFrame")
    inventory.Frame:SetSize(300, 400)
    inventory.Frame:Center()
    inventory.Frame:SetTitle(HLX.Translate("inventory_title"))
    inventory.Frame:MakePopup()
    inventory.Frame.Paint = HLX.Derma.PaintPanel

    inventory.Scroll = inventory.Frame:Add("DScrollPanel")
    inventory.Scroll:Dock(FILL)

    inventory.BuildList()
end

concommand.Add("hlx_inventory", inventory.Toggle)
