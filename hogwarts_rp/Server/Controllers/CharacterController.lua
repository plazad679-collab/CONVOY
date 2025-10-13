local Logger = Package.Require("Shared/Modules/Logger.lua")
local EventBus = Package.Require("Shared/Modules/EventBus.lua")
local CharacterService = Package.Require("Server/Services/CharacterService.lua")
local ScheduleService = Package.Require("Server/Services/ScheduleService.lua")
local SpellService = Package.Require("Server/Services/SpellService.lua")

local CharacterController = {}

Events.Subscribe("PlayerConnected", function(player)
    Logger:info("Jugador %s conectado", player:GetName())
    EventBus:emit("player_connected", player)
end)

Events.Subscribe("PlayerDisconnected", function(player)
    Logger:info("Jugador %s desconectado", player:GetName())
    EventBus:emit("player_disconnected", player)
end)

Events.SubscribeRemote("hogwarts:create_character", function(player, payload)
    local character, err = CharacterService:create(player:GetID(), payload)
    if not character then
        Logger:error("No se pudo crear personaje: %s", err)
        Events.CallRemote("hogwarts:create_character_failed", player, err)
        return
    end

    Events.CallRemote("hogwarts:create_character_success", player, character)
    EventBus:emit("character_created", player, character)
end)

Events.SubscribeRemote("hogwarts:request_characters", function(player)
    local characters = CharacterService:get_player_characters(player:GetID())
    Events.CallRemote("hogwarts:characters", player, characters)
end)

Events.SubscribeRemote("hogwarts:join_class", function(player, data)
    local character = CharacterService:get_character(data.character_id)
    if not character then
        return
    end

    ScheduleService:assign_class(character.id, data.class_id, data.day_of_week, data.starts_at, data.ends_at)
end)

Events.SubscribeRemote("hogwarts:cast_spell", function(player, data)
    local character = CharacterService:get_character(data.character_id)
    if not character then
        Events.CallRemote("hogwarts:cast_spell_failed", player, "character_not_found")
        return
    end

    local allowed, reason = SpellService:can_cast(character, data.spell_id)
    if not allowed then
        Events.CallRemote("hogwarts:cast_spell_failed", player, reason)
        return
    end

    SpellService:register_cast(character, data.spell_id)
    Events.CallRemote("hogwarts:cast_spell_success", player, data.spell_id)
end)

return CharacterController
