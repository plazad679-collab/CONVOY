--[[
    HelixLite - Punto de entrada del cliente.
    Configura carga de módulos y ganchos de UI.
]]

include("shared.lua")

local clientFiles = {
    "cl_derma.lua",
    "cl_notifications.lua",
    "cl_chat.lua",
    "cl_hud.lua",
    "cl_inventory.lua",
    "cl_charactercreator.lua",
    "cl_spells.lua",
    "cl_wands.lua",
    "cl_potions.lua",
    "cl_brooms.lua",
    "cl_lorepacks.lua",
    "cl_plugins.lua"
}

for _, fileName in ipairs(clientFiles) do
    include(fileName)
end

hook.Add("InitPostEntity", "HLX.ClientInit", function()
    HLX.Magic.InitializeDefaults()
    HLX.Factions.Register("students", {
        name = "Students",
        color = Color(120, 180, 255),
        permissions = { "hlx.basic", "hlx.learn" }
    })
    HLX.Notifications.Initialize()
    HLX.Inventory.Initialize()
    HLX.CharacterCreator.Initialize()
    HLX.ClientPlugins.LoadAll()
end)
