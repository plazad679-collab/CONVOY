local Logger = Package.Require("Shared/Modules/Logger.lua")
local Spells = Package.Require("Shared/Data/Spells.lua")
local TableUtils = Package.Require("Shared/Modules/TableUtils.lua")
local MySQL = Package.Require("Server/Database/MySQL.lua")

local SpellService = {}
SpellService.spells = TableUtils.index_by(Spells, "id")

function SpellService:get(spell_id)
    return self.spells[spell_id]
end

function SpellService:list()
    return Spells
end

function SpellService:get_character_spells(character_id)
    local rows = MySQL:select("SELECT * FROM hogwarts_spells WHERE character_id = ?", { character_id }) or {}
    return rows
end

function SpellService:can_cast(character, spell_id)
    local spell = self:get(spell_id)
    if not spell then
        return false, "spell_not_found"
    end

    if character.year < spell.year then
        return false, "year_requirement"
    end

    local cooldown_row = MySQL:select([[SELECT cooldown, last_cast_at FROM hogwarts_spells WHERE character_id = ? AND spell_id = ?]], {
        character.id,
        spell_id
    })

    if cooldown_row and cooldown_row[1] and cooldown_row[1].last_cast_at then
        local last_cast = os.time(cooldown_row[1].last_cast_at)
        local diff = os.time() - last_cast
        local required = cooldown_row[1].cooldown > 0 and cooldown_row[1].cooldown or spell.cooldown
        if diff < required then
            return false, "cooldown"
        end
    end

    return true
end

function SpellService:register_cast(character, spell_id)
    local spell = self:get(spell_id)
    if not spell then
        return false, "spell_not_found"
    end

    MySQL:execute([[UPDATE hogwarts_spells SET
        experience = experience + 1,
        cooldown = ?,
        last_cast_at = NOW()
        WHERE character_id = ? AND spell_id = ?]], {
        spell.cooldown,
        character.id,
        spell_id
    })

    Logger:debug("Registrado lanzamiento de %s por personaje %d", spell_id, character.id)
    return true
end

return SpellService
