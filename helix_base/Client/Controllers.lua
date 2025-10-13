local Helix = Package.GetExports("helix_base").Helix
local Logger = Helix.Logger
local Config = Helix.Config

Helix.Client = Helix.Client or {
    Config = {},
    Permissions = {},
    Character = nil,
    Inventory = {},
    Ready = false
}

Events.SubscribeRemote(Config.Networking.SyncConfigEvent, function(payload)
    Helix.Client.Config = payload.framework or {}
    Helix.Client.Permissions = payload.permissions or {}
    Helix.Client.Chat = payload.chat or {}
    Helix.Client.Ready = true
    Logger:info("Configuración sincronizada: %s", Helix.Client.Config.Name or "Helix")
end)

Events.SubscribeRemote(Config.Networking.SyncCharacterEvent, function(character)
    Helix.Client.Character = character
    if character then
        Logger:info("Personaje activo: %s", character.name or "Sin nombre")
    else
        Logger:warn("No tienes personaje activo")
    end
end)

Events.SubscribeRemote(Config.Networking.SyncInventoryEvent, function(inventory)
    Helix.Client.Inventory = inventory or {}
    Logger:debug("Inventario sincronizado (%d items)", #Helix.Client.Inventory)
end)

return Helix.Client
