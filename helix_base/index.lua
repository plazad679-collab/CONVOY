local Config = Package.Require("Shared/Config.lua")
local Logger = Package.Require("Shared/Modules/Logger.lua")
local Utils = Package.Require("Shared/Modules/Utils.lua")

local Helix = Package.GetExports("helix_base") and Package.GetExports("helix_base").Helix or {}

Helix.Version = Helix.Version or "0.1.0"
Helix.IsServer = Server ~= nil
Helix.IsClient = Client ~= nil
Helix.Config = Config
Helix.Utils = Utils
Helix.Logger = Logger
Helix.Modules = Helix.Modules or {}
Helix.Commands = Helix.Commands or {}
Helix.Players = Helix.Players or {}
Helix.Characters = Helix.Characters or {}
Helix.Items = Helix.Items or {}
Helix.Started = true

function Helix.RegisterModule(name, module)
    if not name or name == "" then
        Logger:error("Intento de registrar un módulo sin nombre")
        return
    end

    module = module or {}
    Helix.Modules[name] = module
    Logger:debug("Módulo '%s' registrado", name)
    return module
end

function Helix.GetModule(name)
    return Helix.Modules[name]
end

function Helix.RegisterCommand(name, data)
    if not name or name == "" then
        Logger:error("Intento de registrar un comando sin nombre")
        return
    end

    Helix.Commands[name] = data
    Logger:debug("Comando '%s' registrado", name)
end

function Helix.GetCommand(name)
    return Helix.Commands[name]
end

Package.Export("Helix", Helix)

if Helix.IsServer then
    Logger:info("Helix Base %s cargada en el servidor", Helix.Version)
else
    Logger:info("Helix Base %s cargada en el cliente", Helix.Version)
end

return Helix
