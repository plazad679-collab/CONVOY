AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

Hogwarts.PrintBanner()

Hogwarts.Loader.IncludeFolder("config")
Hogwarts.Loader.IncludeFolder("data")
Hogwarts.Loader.IncludeFolder("core")
Hogwarts.Loader.IncludeFolder("modules")

hook.Add("Initialize", "Hogwarts.Initialize", function()
    if Hogwarts.Modules.Characters and Hogwarts.Modules.Characters.Initialize then
        Hogwarts.Modules.Characters:Initialize()
    end
    if Hogwarts.Modules.Spells and Hogwarts.Modules.Spells.Initialize then
        Hogwarts.Modules.Spells:Initialize()
    end
end)

hook.Add("PlayerInitialSpawn", "Hogwarts.PlayerInitialSpawn", function(ply)
    if not Hogwarts.Modules.Characters then return end
    Hogwarts.Modules.Characters:LoadPlayer(ply)
    Hogwarts.Modules.Characters:Sync(ply)
    Hogwarts.Modules.Spells:Sync(ply)
end)

hook.Add("PlayerDisconnected", "Hogwarts.PlayerDisconnected", function(ply)
    if not Hogwarts.Modules.Characters then return end
    Hogwarts.Modules.Characters:SavePlayer(ply)
end)
