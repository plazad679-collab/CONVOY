--[[
    HelixLite - Archivo compartido principal.
    Carga utilidades, configuraciones y módulos compartidos.
]]

HLX = HLX or {}
HLX.Version = "1.0.0"

HLX.IncludeShared = HLX.IncludeShared or function(path)
    if SERVER then
        AddCSLuaFile(path)
    end
    include(path)
end

HLX.IncludeClient = HLX.IncludeClient or function(path)
    if SERVER then
        AddCSLuaFile(path)
    elseif CLIENT then
        include(path)
    end
end

HLX.IncludeServer = HLX.IncludeServer or function(path)
    if SERVER then
        include(path)
    end
end

local sharedFiles = {
    "sh_util.lua",
    "sh_hooks.lua",
    "sh_config.lua",
    "sh_permissions.lua",
    "sh_factions.lua",
    "sh_languages.lua",
    "sh_magic.lua",
    "sh_potions.lua",
    "sh_zones.lua"
}

for _, fileName in ipairs(sharedFiles) do
    HLX.IncludeShared(fileName)
end

-- Carga de archivos adicionales compartidos desde carpetas específicas.
local folders = {
    "core",
    "modules"
}

for _, folder in ipairs(folders) do
    local files, _ = file.Find("helixlite/gamemode/" .. folder .. "/*.lua", "LUA")
    for _, fileName in ipairs(files) do
        HLX.IncludeShared(folder .. "/" .. fileName)
    end
end

-- Inicializa tablas globales para registros.
HLX.Items = HLX.Items or {}
HLX.RegisteredItems = HLX.RegisteredItems or {}
HLX.Factions = HLX.Factions or {}
HLX.Commands = HLX.Commands or {}
HLX.Plugins = HLX.Plugins or {}
HLX.Magic = HLX.Magic or { Spells = {}, Wands = {} }
HLX.Zones = HLX.Zones or {}
HLX.Lorepacks = HLX.Lorepacks or {}
HLX.Potions = HLX.Potions or { Recipes = {} }
HLX.Brooms = HLX.Brooms or {}
HLX.Wands = HLX.Wands or {}
