--[[
    Localización básica.
]]

HLX = HLX or {}
HLX.Languages = HLX.Languages or {}

HLX.Languages["es-ES"] = {
    hud_health = "Salud",
    hud_armor = "Armadura",
    hud_mana = "Maná",
    hud_money = "Galleons",
    hud_spell_ready = "Hechizo listo",
    command_invalid = "Comando inválido.",
    command_no_permission = "No tienes permiso.",
    inventory_title = "Inventario",
    inventory_weight = "Peso",
    character_create = "Crear Personaje",
    character_select_house = "Selecciona Casa o Rol",
    notification_spell_failed = "El hechizo falló",
    notification_spell_success = "Hechizo lanzado",
    notification_item_received = "Has recibido un ítem",
    lorepack_enabled = "Lorepack activado",
    lorepack_disabled = "Lorepack desactivado"
}

HLX.Language = "es-ES"

function HLX.Translate(key)
    local langTable = HLX.Languages[HLX.Language] or {}
    return langTable[key] or key
end

return HLX.Languages
