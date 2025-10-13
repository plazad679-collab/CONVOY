-- cl_init.lua
-- Punto de entrada del cliente para GarkravallRP.

include("shared.lua")
include("ui/hud.lua")

hook.Add("InitPostEntity", "Garkravall_ClientInitialized", function()
    Garkravall.InitializeClient()
    if Garkravall.UI and Garkravall.UI.Initialize then
        Garkravall.UI.Initialize()
    end
end)

hook.Add("HUDShouldDraw", "Garkravall_DisableDefaultHUD", function(name)
    local blocked = {
        "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"
    }
    if table.HasValue(blocked, name) then
        return false
    end
end)
