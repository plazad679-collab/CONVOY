--[[
    Cargador de plugins cliente.
]]

HLX.ClientPlugins = HLX.ClientPlugins or {}
local clientPlugins = HLX.ClientPlugins

clientPlugins.Registered = clientPlugins.Registered or {}

local function loadPlugin(path)
    local metaPath = path .. "/sh_plugin.lua"
    if not file.Exists(metaPath, "LUA") then return end
    local plugin = include(metaPath)
    if plugin and plugin.client and plugin.client.init then
        HLX.Util.SafeCall(plugin.client.init)
    end
    clientPlugins.Registered[plugin.name or path] = plugin
end

function clientPlugins.LoadAll()
    local files, dirs = file.Find("helixlite/gamemode/plugins/*", "LUA")
    for _, dir in ipairs(dirs) do
        loadPlugin("helixlite/gamemode/plugins/" .. dir)
    end
end

return clientPlugins
