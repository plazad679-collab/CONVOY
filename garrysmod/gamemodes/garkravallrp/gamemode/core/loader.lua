-- core/loader.lua
-- Carga automática de módulos y archivos compartidos.

Garkravall = Garkravall or {}

local function includeFile(path)
    if SERVER then
        AddCSLuaFile(path)
    end
    include(path)
end

function Garkravall.LoadCore()
    includeFile("core/config.lua")
    includeFile("core/api.lua")
    includeFile("core/database.lua")
    includeFile("core/player.lua")
    includeFile("core/spells.lua")
end

local function loadModules()
    local _, directories = file.Find("modules/*", "LUA")

    for _, dir in ipairs(directories) do
        local files = file.Find("modules/" .. dir .. "/*.lua", "LUA")
        for _, fileName in ipairs(files) do
            local path = "modules/" .. dir .. "/" .. fileName
            if SERVER then
                AddCSLuaFile(path)
            end
            include(path)
        end
    end

    Garkravall.BroadcastEvent("ModulesLoaded")
end

if not Garkravall.CoreLoaded then
    Garkravall.LoadCore()
    Garkravall.CoreLoaded = true
    loadModules()
end
