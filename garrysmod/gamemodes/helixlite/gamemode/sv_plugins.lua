--[[
    Cargador de plugins servidor.
]]

HLX.Plugins = HLX.Plugins or {}
local plugins = HLX.Plugins

plugins.Registered = plugins.Registered or {}

local function loadPlugin(path)
    local metaPath = path .. "/sh_plugin.lua"
    if not file.Exists(metaPath, "LUA") then return end
    AddCSLuaFile(metaPath)
    local plugin = include(metaPath)
    if plugin and plugin.server and plugin.server.init then
        HLX.Util.SafeCall(plugin.server.init)
    end
    plugins.Registered[plugin.name or path] = plugin
end

function plugins.LoadAll()
    local files, dirs = file.Find("helixlite/gamemode/plugins/*", "LUA")
    for _, dir in ipairs(dirs) do
        loadPlugin("helixlite/gamemode/plugins/" .. dir)
    end
end

return plugins
