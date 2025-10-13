local Hogwarts = Package.GetExports("hogwarts_rp") and Package.GetExports("hogwarts_rp").Hogwarts or {}

Hogwarts.Version = Hogwarts.Version or "0.1.0"
Hogwarts.IsServer = Server ~= nil
Hogwarts.IsClient = Client ~= nil

Hogwarts.Config = Hogwarts.Config or {}
Hogwarts.Services = Hogwarts.Services or {}
Hogwarts.Controllers = Hogwarts.Controllers or {}
Hogwarts.Modules = Hogwarts.Modules or {}
Hogwarts.Data = Hogwarts.Data or {}

Package.Export("Hogwarts", Hogwarts)

if Hogwarts.IsServer then
    Package.Require("Server/index.lua")
else
    Package.Require("Client/Controllers.lua")
end

return Hogwarts
