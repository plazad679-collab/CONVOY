local Spells = Hogwarts.Modules.Spells
local Characters = Hogwarts.Modules.Characters
local Net = Hogwarts.Core.Net
local Logger = Hogwarts.Core.Logger

function Spells:Initialize()
    Logger:Success("Sistema de hechizos listo")
end

function Spells:Sync(ply)
    local key = Characters:GetPlayerKey(ply)
    local characters = Characters.Cache[key] or {}
    if not characters[1] then return end
    Net.Send(ply, Net.Messages.SpellsSync, characters[1].spells or {})
end

net.Receive(Net.Messages.SpellCast, function(_, ply)
    local payload = net.ReadTable() or {}
    if not payload.character_id or not payload.spell_id then return end

    local character = Characters:Find(ply, payload.character_id)
    if not character then
        Net.Send(ply, Net.Messages.SpellFailed, { reason = "character_not_found" })
        return
    end

    local allowed, reason = Spells:CanCast(ply, character, payload.spell_id)
    if not allowed then
        Net.Send(ply, Net.Messages.SpellFailed, { reason = reason })
        return
    end

    Spells:ApplyCooldown(character, payload.spell_id)
    Logger:Info("%s lanzó %s", ply:Nick(), payload.spell_id)
    Net.Send(ply, Net.Messages.SpellCast, payload)
    Hogwarts.Core.EventBus:Emit("spell_cast", ply, character, payload.spell_id)
end)

return Spells
