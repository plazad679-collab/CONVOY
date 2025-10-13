-- ui/hud.lua
-- Renderiza la interfaz mediante un panel DHTML.

Garkravall = Garkravall or {}
Garkravall.UI = Garkravall.UI or {}

local hudPanel
local assetURL = "asset://garrysmod/gamemodes/garkravallrp/gamemode/ui/html/index.html"

local function createHUD()
    if IsValid(hudPanel) then return end

    hudPanel = vgui.Create("DHTML")
    hudPanel:SetSize(ScrW(), ScrH())
    hudPanel:SetPos(0, 0)
    hudPanel:SetZPos(10)
    hudPanel:OpenURL(assetURL)
    hudPanel:SetAllowLua(true)

    hudPanel:AddFunction("garkravall", "requestSpell", function(identifier)
        if Garkravall.RequestSpellCast then
            Garkravall.RequestSpellCast(identifier)
        end
        if Garkravall.Duels and Garkravall.Duels.RequestProjectile then
            Garkravall.Duels:RequestProjectile(identifier)
        end
    end)

    hudPanel:AddFunction("garkravall", "selectHouse", function(house)
        net.Start("garkravall_ui_command")
        net.WriteString("select_house")
        net.WriteString(house)
        net.SendToServer()
    end)

    hudPanel:AddFunction("garkravall", "selectCharacter", function(index)
        if Garkravall.UI.SelectCharacter then
            Garkravall.UI.SelectCharacter(index)
        end
    end)

    Garkravall.UI.Panel = hudPanel
end

function Garkravall.UI.Initialize()
    createHUD()
end

function Garkravall.UI.Update(payload)
    if not IsValid(hudPanel) then return end
    local json = util.TableToJSON(payload)
    hudPanel:Call(string.format("window.Garkravall && window.Garkravall.update(%s);", json))
end

function Garkravall.UI.OnData(payload)
    Garkravall.UI.Update(payload)
end

hook.Add("OnScreenSizeChanged", "Garkravall_ResizeHUD", function()
    if not IsValid(hudPanel) then return end
    hudPanel:SetSize(ScrW(), ScrH())
end)
