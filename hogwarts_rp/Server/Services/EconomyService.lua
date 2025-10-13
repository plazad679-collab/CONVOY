local Logger = Package.Require("Shared/Modules/Logger.lua")
local MySQL = Package.Require("Server/Database/MySQL.lua")

local EconomyService = {}

function EconomyService:adjust_balance(character_id, delta)
    local result, err = MySQL:execute([[UPDATE hogwarts_characters SET
        currency_galeons = currency_galeons + ?,
        currency_sickles = currency_sickles + ?,
        currency_knuts = currency_knuts + ?
        WHERE id = ?]], {
        delta.galeons or 0,
        delta.sickles or 0,
        delta.knuts or 0,
        character_id
    })

    if not result then
        Logger:error("No se pudo ajustar balance: %s", err or "desconocido")
        return false, err
    end

    Logger:info("Balance ajustado para personaje %d: %+dg %+ds %+dk", character_id, delta.galeons or 0, delta.sickles or 0, delta.knuts or 0)
    return true
end

function EconomyService:get_balance(character_id)
    local rows = MySQL:select("SELECT currency_galeons, currency_sickles, currency_knuts FROM hogwarts_characters WHERE id = ?", { character_id })
    if not rows or not rows[1] then
        return { galeons = 0, sickles = 0, knuts = 0 }
    end
    return {
        galeons = rows[1].currency_galeons,
        sickles = rows[1].currency_sickles,
        knuts = rows[1].currency_knuts
    }
end

return EconomyService
