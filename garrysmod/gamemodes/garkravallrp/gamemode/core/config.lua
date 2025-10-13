-- core/config.lua
-- Se encarga de exponer la configuración global del gamemode.

Garkravall = Garkravall or {}

local config = include("config/settings.lua")

Garkravall.Config = config

function Garkravall.GetConfig(path, default)
    local current = config
    for segment in string.gmatch(path, "[^%.]+") do
        current = current and current[segment]
    end
    if current == nil then
        return default
    end
    return current
end
