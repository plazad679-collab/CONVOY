local Spells = {}
Spells.Data = Hogwarts.Data.Spells
Spells.Index = Hogwarts.Core.TableUtils.IndexBy(Spells.Data, "id")
Spells.Cooldowns = Spells.Cooldowns or {}

function Spells:Get(character, spell_id)
    for _, spell in ipairs(character.spells or {}) do
        if spell.spell_id == spell_id then
            return spell
        end
    end
end

function Spells:GetDefinition(spell_id)
    return self.Index[spell_id]
end

function Spells:CanCast(ply, character, spell_id)
    local definition = self:GetDefinition(spell_id)
    if not definition then
        return false, "spell_unknown"
    end

    if definition.year > (character.year or Hogwarts.Config.Gameplay.starting_year) then
        return false, "year_restricted"
    end

    local cooldowns = self.Cooldowns[character.id] or {}
    local expire = cooldowns[spell_id] or 0
    if expire > CurTime() then
        return false, "cooldown"
    end

    return true
end

function Spells:ApplyCooldown(character, spell_id)
    self.Cooldowns[character.id] = self.Cooldowns[character.id] or {}
    local definition = self:GetDefinition(spell_id)
    local cooldown = definition and definition.cooldown or Hogwarts.Config.Gameplay.spell_cooldown
    self.Cooldowns[character.id][spell_id] = CurTime() + cooldown
end

function Spells:Sync(ply)
    local characters = Hogwarts.Modules.Characters.Cache[Hogwarts.Modules.Characters:GetPlayerKey(ply)] or {}
    if not characters[1] then return end
    Hogwarts.Core.Net.Send(ply, Hogwarts.Core.Net.Messages.SpellsSync, characters[1].spells or {})
end

Hogwarts.Modules.Spells = Spells

return Spells
