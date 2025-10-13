local Helix = Package.GetExports("helix_base").Helix
local Logger = Helix.Logger
local Config = Helix.Config
local Utils = Helix.Utils
local PlayerManager = Helix.GetModule("PlayerManager")

local CharacterManager = Helix.RegisterModule("CharacterManager", {})

local function create_character(player_id, overrides)
    if not Helix.Characters[player_id] then
        Helix.Characters[player_id] = {}
    end

    local characters = Helix.Characters[player_id]

    if #characters >= Config.Characters.MaxPerPlayer then
        return false, "Has alcanzado el número máximo de personajes"
    end

    local character = {
        id = Utils.uuid and Utils.uuid() or tostring(os.time()) .. tostring(math.random(1000, 9999)),
        name = overrides and overrides.name or ("Personaje %s"):format(#characters + 1),
        created_at = os.time(),
        model = Config.Characters.DefaultModel,
        position = Config.Characters.DefaultSpawn
    }

    if overrides then
        for k, v in pairs(overrides) do
            character[k] = v
        end
    end

    table.insert(characters, character)
    Logger:info("Nuevo personaje creado para %s", player_id)

    return true, character
end

function CharacterManager.Create(player, overrides)
    local success, result = create_character(player:GetID(), overrides)
    if not success then
        return success, result
    end

    PlayerManager.BroadcastState(player)
    return success, result
end

function CharacterManager.Select(player, character_id)
    local list = Helix.Characters[player:GetID()] or {}
    for _, character in ipairs(list) do
        if character.id == character_id then
            Events.CallRemote(Config.Networking.SyncCharacterEvent, player, character)
            Logger:info("%s seleccionó el personaje %s", player:GetName(), character.name)
            return true, character
        end
    end
    return false, "Personaje no encontrado"
end

return CharacterManager
