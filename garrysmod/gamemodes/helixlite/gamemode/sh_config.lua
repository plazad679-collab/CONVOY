--[[
    Configuración compartida de HelixLite.
]]

HLX.Config = HLX.Config or {}

-- Convars base.
if SERVER then
    CreateConVar("hlx_servername", "HelixLite RP", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Nombre del servidor")
    CreateConVar("hlx_command_prefix", "/", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Prefijo de comandos de chat")
    CreateConVar("hlx_enable_persistence", "1", FCVAR_ARCHIVE, "Activa persistencia en SQLite")
    CreateConVar("hlx_currency_name", "Galleons", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Nombre de la moneda base")
    CreateConVar("hlx_inventory_slots", "24", FCVAR_ARCHIVE, "Número de slots de inventario")
    CreateConVar("hlx_inventory_maxweight", "50", FCVAR_ARCHIVE, "Peso máximo del inventario")
    CreateConVar("hlx_enable_lorepack", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Activa el lorepack seleccionado")
    CreateConVar("hlx_lorepack_active", "", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Lorepack actual")
    CreateConVar("hlx_magic_mana_base", "100", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Maná base de los jugadores")
    CreateConVar("hlx_magic_global_cooldown", "0.5", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Cooldown global de hechizos")
end

HLX.Config.CommandPrefix = GetConVar("hlx_command_prefix"):GetString()
HLX.Config.CurrencyName = GetConVar("hlx_currency_name"):GetString()
HLX.Config.InventorySlots = GetConVar("hlx_inventory_slots"):GetInt()
HLX.Config.InventoryMaxWeight = GetConVar("hlx_inventory_maxweight"):GetFloat()
HLX.Config.EnableLorepack = GetConVar("hlx_enable_lorepack"):GetBool()
HLX.Config.ActiveLorepack = GetConVar("hlx_lorepack_active"):GetString()
HLX.Config.ManaBase = GetConVar("hlx_magic_mana_base"):GetInt()
HLX.Config.GlobalSpellCooldown = GetConVar("hlx_magic_global_cooldown"):GetFloat()

HLX.Config.InventoryMode = "slots" -- slots o peso
HLX.Config.AllowLorepackToggle = true

cvars.AddChangeCallback("hlx_currency_name", function(_, _, new)
    HLX.Config.CurrencyName = new
end, "HLX_CurrencyName")

cvars.AddChangeCallback("hlx_enable_lorepack", function(_, _, new)
    HLX.Config.EnableLorepack = tobool(new)
end, "HLX_EnableLorepack")

cvars.AddChangeCallback("hlx_lorepack_active", function(_, _, new)
    HLX.Config.ActiveLorepack = new
end, "HLX_ActiveLorepack")

return HLX.Config
