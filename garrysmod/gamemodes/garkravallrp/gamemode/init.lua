-- init.lua
-- Punto de entrada del lado del servidor para GarkravallRP.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local coreFiles = {
    "core/loader.lua",
    "core/config.lua",
    "core/api.lua",
    "core/database.lua",
    "core/player.lua",
    "core/spells.lua",
    "ui/hud.lua"
}

for _, fileName in ipairs(coreFiles) do
    AddCSLuaFile(fileName)
end

if SERVER then
    resource.AddSingleFile("gamemodes/garkravallrp/gamemode/ui/html/index.html")
    resource.AddSingleFile("gamemodes/garkravallrp/gamemode/ui/html/style.css")
    resource.AddSingleFile("gamemodes/garkravallrp/gamemode/ui/html/script.js")
end

include("shared.lua")

hook.Add("Initialize", "Garkravall_ServerInitialize", function()
    Garkravall.Database.Initialize()
    Garkravall.InitializeServer()
end)

hook.Add("PlayerSpawn", "Garkravall_PlayerSpawnLoadout", function(ply)
    ply:Give("weapon_crowbar")
    ply:Give("weapon_physgun")
    ply:SelectWeapon("weapon_physgun")
end)

hook.Add("Think", "Garkravall_AutoSave", function()
    if not Garkravall._nextSave or Garkravall._nextSave < CurTime() then
        Garkravall._nextSave = CurTime() + 300
        for _, ply in ipairs(player.GetAll()) do
            Garkravall.Database.SavePlayer(ply)
        end
    end
end)
