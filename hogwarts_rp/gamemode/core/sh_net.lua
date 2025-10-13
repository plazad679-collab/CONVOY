local Net = {}

Net.Messages = {
    CharactersRequest = "hogwarts_characters_request",
    CharactersSync = "hogwarts_characters_sync",
    CharacterCreated = "hogwarts_character_created",
    CharacterError = "hogwarts_character_error",
    CharacterSelect = "hogwarts_character_select",
    SpellsSync = "hogwarts_spells_sync",
    SpellCast = "hogwarts_spell_cast",
    SpellFailed = "hogwarts_spell_failed"
}

if SERVER then
    for _, message in pairs(Net.Messages) do
        util.AddNetworkString(message)
    end
end

function Net.Send(ply, message, payload)
    if SERVER then
        net.Start(message)
        net.WriteTable(payload or {})
        net.Send(ply)
    end
end

function Net.Broadcast(message, payload)
    if SERVER then
        net.Start(message)
        net.WriteTable(payload or {})
        net.Broadcast()
    end
end

Hogwarts.Core.Net = Net

return Net
