--[[
    Selector y creador de personajes con sombrero seleccionador.
]]

HLX.CharacterCreator = HLX.CharacterCreator or {}
local creator = HLX.CharacterCreator

creator.Frame = nil
creator.Houses = {
    students = { name = "Students" }
}

function creator.Initialize()
    if not creator.Houses or table.IsEmpty(creator.Houses) then
        creator.Houses = {}
        for id, data in pairs(HLX.Factions.Stored or {}) do
            creator.Houses[id] = data
        end
    end
end

local function sendCreate(name, faction)
    RunConsoleCommand("say", string.format("%scharcreate %s %s", HLX.Config.CommandPrefix, name, faction))
end

function creator.Open()
    if IsValid(creator.Frame) then
        creator.Frame:Remove()
    end

    creator.Frame = vgui.Create("DFrame")
    creator.Frame:SetSize(400, 300)
    creator.Frame:Center()
    creator.Frame:SetTitle(HLX.Translate("character_create"))
    creator.Frame:MakePopup()
    creator.Frame.Paint = HLX.Derma.PaintPanel

    local nameEntry = creator.Frame:Add("DTextEntry")
    nameEntry:Dock(TOP)
    nameEntry:DockMargin(10, 10, 10, 10)
    nameEntry:SetPlaceholderText("Nombre del personaje")

    local factionList = creator.Frame:Add("DComboBox")
    factionList:Dock(TOP)
    factionList:DockMargin(10, 0, 10, 10)
    factionList:SetValue(HLX.Translate("character_select_house"))

    for id, data in pairs(creator.Houses) do
        factionList:AddChoice(data.name or id, id)
    end

    local hatLabel = creator.Frame:Add("DLabel")
    hatLabel:Dock(TOP)
    hatLabel:DockMargin(10, 0, 10, 10)
    hatLabel:SetTall(40)
    hatLabel:SetWrap(true)
    hatLabel:SetText("Sombrero seleccionador: esperando...")

    local confirm = creator.Frame:Add("DButton")
    confirm:Dock(BOTTOM)
    confirm:DockMargin(10, 10, 10, 10)
    confirm:SetTall(40)
    confirm:SetText("Crear personaje")
    confirm.Paint = HLX.Derma.PaintButton

    confirm.DoClick = function()
        local name = nameEntry:GetValue()
        if name == "" then
            hatLabel:SetText("Necesitas un nombre válido")
            return
        end
        local _, faction = factionList:GetSelected()
        if not faction then
            local keys = table.GetKeys(creator.Houses or {})
            if #keys > 0 then
                faction = keys[math.random(#keys)]
                hatLabel:SetText("El sombrero te asigna a " .. (creator.Houses[faction].name or faction))
            else
                faction = "students"
                hatLabel:SetText("El sombrero no encuentra casas, usando Students")
            end
        else
            hatLabel:SetText("El sombrero aprueba tu elección: " .. (creator.Houses[faction].name or faction))
        end
        sendCreate(name, faction)
        timer.Simple(1, function()
            if IsValid(creator.Frame) then
                creator.Frame:Close()
            end
        end)
    end
end

concommand.Add("hlx_charcreate", creator.Open)
