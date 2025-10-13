local EventBus = Package.Require("Shared/Modules/EventBus.lua")
local SpellService = Package.Require("Server/Services/SpellService.lua")

local SpellController = {}

EventBus:subscribe("character_created", function(player, character)
    local spells = SpellService:get_character_spells(character.id)
    Events.CallRemote("hogwarts:spells_updated", player, spells)
end)

return SpellController
