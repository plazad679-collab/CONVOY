local Helix = Package.GetExports("helix_base").Helix
local Logger = Helix.Logger
local Config = Helix.Config
local Utils = Helix.Utils

local PlayerManager = Helix.RegisterModule("PlayerManager", {})

local function give_start_items(player_id)
    local inventory = Helix.Items[player_id] or {}
    for _, item in ipairs(Config.Inventory.StartItems or {}) do
        table.insert(inventory, Utils.deepcopy(item))
    end
    Helix.Items[player_id] = inventory
end

local function broadcast_state(player)
    Events.CallRemote(Config.Networking.SyncCharacterEvent, player, Helix.Characters[player:GetID()])
    Events.CallRemote(Config.Networking.SyncInventoryEvent, player, Helix.Items[player:GetID()] or {})
end

Events.Subscribe("PlayerJoin", function(player)
    local player_id = player:GetID()
    Helix.Players[player_id] = {
        id = player_id,
        name = player:GetName(),
        permission = Config.Permissions.Default,
        created_at = os.time()
    }

    Logger:info("Jugador %s (%s) conectado", player:GetName(), player_id)

    give_start_items(player_id)

    Events.CallRemote(Config.Networking.SyncConfigEvent, player, {
        framework = Config.Framework,
        chat = Config.Chat,
        permissions = Config.Permissions
    })

    broadcast_state(player)
end)

Events.Subscribe("PlayerQuit", function(player)
    local player_id = player:GetID()
    Helix.Players[player_id] = nil
    Helix.Characters[player_id] = nil
    Helix.Items[player_id] = nil

    Logger:info("Jugador %s (%s) desconectado", player:GetName(), player_id)
end)

PlayerManager.BroadcastState = broadcast_state

return PlayerManager
