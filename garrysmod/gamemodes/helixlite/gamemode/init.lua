--[[
    HelixLite - Punto de entrada del servidor.
    Configura carga de módulos, recursos y redes.
]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

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
    AddCSLuaFile(fileName)
end

include("shared.lua")

resource.AddFile = resource.AddFile or function() end
-- resource.AddFile("materials/hlx_placeholder.vmt")
-- resource.AddFile("sound/hlx_placeholder.wav")

local serverFiles = {
    "sv_logging.lua",
    "sv_database.lua",
    "sv_persistence.lua",
    "sv_factions.lua",
    "sv_items.lua",
    "sv_inventory.lua",
    "sv_characters.lua",
    "sv_wands.lua",
    "sv_spells.lua",
    "sv_potions.lua",
    "sv_brooms.lua",
    "sv_rules.lua",
    "sv_commands.lua",
    "sv_plugins.lua",
    "sv_lorepacks.lua"
}

for _, fileName in ipairs(serverFiles) do
    include(fileName)
end

-- Configuración de canales de red.
local networkChannels = {
    "hlx_inventory",
    "hlx_notifications",
    "hlx_ui",
    "hlx_commands",
    "hlx_spells",
    "hlx_wands",
    "hlx_potions",
    "hlx_brooms"
}

for _, channel in ipairs(networkChannels) do
    util.AddNetworkString(channel)
end

hook.Add("Initialize", "HLX.Init", function()
    HLX.DB.Connect()
    HLX.DB.InitSchema()
    HLX.Logging.Info("HelixLite servidor inicializado.")
    HLX.Factions.InitializeDefaults()
    HLX.Items.InitializeDefaults()
    HLX.Magic.InitializeDefaults()
    if HLX.Zones.InitializeDefaults then
        HLX.Zones.InitializeDefaults()
    end
    HLX.Plugins.LoadAll()
    HLX.Lorepacks.Initialize()
end)

hook.Add("PlayerInitialSpawn", "HLX.PlayerInitialSpawn", function(ply)
    ply:SetNWInt("hlx_mana", HLX.Config.ManaBase)
    HLX.Persistence.LoadPlayer(ply)
    if HLX.Lorepacks and HLX.Lorepacks.SendTo then
        HLX.Lorepacks.SendTo(ply)
    end
end)

hook.Add("PlayerDisconnected", "HLX.PlayerDisconnected", function(ply)
    HLX.Persistence.SavePlayer(ply)
end)
