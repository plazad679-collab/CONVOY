-- core/api.lua
-- Define la API global de Garkravall para interacción entre módulos.

Garkravall = Garkravall or {}
Garkravall.Modules = Garkravall.Modules or {}
Garkravall.PlayerData = Garkravall.PlayerData or {}
Garkravall.InternalHooks = Garkravall.InternalHooks or {}

local logPrefixColor = Color(147, 112, 219)
local logTextColor = Color(220, 220, 220)

function Garkravall.Log(message)
    message = tostring(message)
    if SERVER then
        MsgC(logPrefixColor, "[Garkravall] ", logTextColor, message .. "\n")
    else
        MsgC(logPrefixColor, "[Garkravall] ", logTextColor, message .. "\n")
    end
end

function Garkravall.RegisterModule(name, moduleTable)
    if not name or name == "" then
        return error("[Garkravall] Intento de registrar un módulo sin nombre.")
    end

    moduleTable = moduleTable or {}
    moduleTable.Name = name
    Garkravall.Modules[name] = moduleTable

    if moduleTable.Init then
        moduleTable:Init()
    end

    Garkravall.Log("Módulo registrado: " .. name)
end

function Garkravall.GetModule(name)
    return Garkravall.Modules[name]
end

function Garkravall.GetPlayerData(ply)
    if not IsValid(ply) then return {} end

    local identifier = ply:SteamID64() or ("bot:" .. ply:EntIndex())
    Garkravall.PlayerData[identifier] = Garkravall.PlayerData[identifier] or {
        money = Garkravall.GetConfig("Economy.startingMoney", 0),
        house = "Sin Casa",
        level = 1,
        year = 1,
        mana = 100,
        experience = 0,
        reputation = 0
    }

    return Garkravall.PlayerData[identifier]
end

function Garkravall.SetPlayerData(ply, key, value)
    local data = Garkravall.GetPlayerData(ply)
    data[key] = value
end

function Garkravall.BroadcastEvent(eventName, ...)
    hook.Run("Garkravall_" .. eventName, ...)
end

function Garkravall.AddInternalHook(eventName, uniqueID, callback)
    hook.Add("Garkravall_" .. eventName, uniqueID, callback)
end

function Garkravall.RemoveInternalHook(eventName, uniqueID)
    hook.Remove("Garkravall_" .. eventName, uniqueID)
end

function Garkravall.InitializeServer()
    Garkravall.Log("Servidor iniciado correctamente.")
    Garkravall.BroadcastEvent("ServerInitialized")
end

function Garkravall.InitializeClient()
    Garkravall.Log("Cliente inicializado.")
    Garkravall.BroadcastEvent("ClientInitialized")
end
