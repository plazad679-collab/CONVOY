--[[
    Utilidades compartidas de HelixLite.
]]

HLX = HLX or {}
HLX.Util = HLX.Util or {}

local utilLib = HLX.Util

--- Ejecuta una función de manera segura capturando errores.
-- @param fn function
-- @param ... argumentos
function utilLib.SafeCall(fn, ...)
    if not isfunction(fn) then return false, "Función inválida" end
    local ok, result = xpcall(fn, debug.traceback, ...)
    if not ok then
        ErrorNoHalt("[HelixLite] Error en SafeCall: " .. tostring(result) .. "\n")
    end
    return ok, result
end

--- Copia profunda de tablas.
function utilLib.DeepCopy(tbl)
    if type(tbl) ~= "table" then return tbl end
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = utilLib.DeepCopy(v)
    end
    return copy
end

--- Limita un número entre min y max.
function utilLib.Clamp(value, min, max)
    min = min or value
    max = max or value
    if value < min then return min end
    if value > max then return max end
    return value
end

--- Genera un ID simple basado en tiempo y aleatorio.
function utilLib.GenerateID(prefix)
    prefix = prefix or "HLX"
    return string.format("%s_%s_%04d", prefix, os.time(), math.random(0, 9999))
end

--- Limpia texto removiendo espacios y control.
function utilLib.SanitizeText(text)
    if not isstring(text) then return "" end
    text = string.gsub(text, "[%c]", "")
    text = string.Trim(text)
    return text
end

--- Valida longitud de texto.
function utilLib.ValidateLength(text, minLen, maxLen)
    local len = utf8.len(text or "") or 0
    if minLen and len < minLen then return false end
    if maxLen and len > maxLen then return false end
    return true
end

--- Formatea moneda.
function utilLib.FormatMoney(amount)
    return string.Comma(math.floor(amount or 0)) .. " " .. (HLX.Config.CurrencyName or "Galleons")
end

--- Obtiene color por casa/rol.
function utilLib.GetFactionColor(factionID)
    local faction = HLX.Factions.Get(factionID)
    if not faction then
        return Color(200, 200, 200)
    end
    return faction.color or Color(200, 200, 200)
end

return utilLib
