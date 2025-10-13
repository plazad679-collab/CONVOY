include("shared.lua")

Hogwarts.Loader.IncludeFolder("config")
Hogwarts.Loader.IncludeFolder("data")
Hogwarts.Loader.IncludeFolder("core")
Hogwarts.Loader.IncludeFolder("modules")

hook.Add("InitPostEntity", "Hogwarts.ClientInit", function()
    if Hogwarts.Modules.Interface and Hogwarts.Modules.Interface.Initialize then
        Hogwarts.Modules.Interface:Initialize()
    end
end)
