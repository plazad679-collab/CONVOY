--[[
    Gestión de lorepacks.
]]

HLX.Lorepacks = HLX.Lorepacks or {}
local lorepacks = HLX.Lorepacks

lorepacks.Active = lorepacks.Active or nil

local function loadLorepack(id)
    local basePath = "helixlite/gamemode/lorepacks/" .. id .. "/sh_lore_config.lua"
    if not file.Exists(basePath, "LUA") then return nil end
    AddCSLuaFile(basePath)
    return include(basePath)
end

function lorepacks.SendTo(ply)
    if not lorepacks.Active then return end
    net.Start("hlx_ui")
    net.WriteString("lorepack_load")
    net.WriteString(lorepacks.Active)
    net.Send(ply)
end

function lorepacks.Initialize()
    if HLX.Config.EnableLorepack and HLX.Config.ActiveLorepack ~= "" then
        lorepacks.Enable(HLX.Config.ActiveLorepack)
    end
end

function lorepacks.Enable(id)
    local config = loadLorepack(id)
    if not config then return false end
    lorepacks.Active = id
    HLX.Config.ActiveLorepack = id
    HLX.Config.EnableLorepack = true
    RunConsoleCommand("hlx_lorepack_active", id)
    RunConsoleCommand("hlx_enable_lorepack", "1")
    if config.factions then
        for factionID, data in pairs(config.factions) do
            HLX.Factions.Register(factionID, data)
        end
    end
    if config.roles then
        for roleID, data in pairs(config.roles) do
            HLX.Permissions.Roles[roleID] = data
        end
    end
    if config.spells then
        for id, data in pairs(config.spells) do
            HLX.Magic.RegisterSpell(id, data)
        end
    end
    if config.items then
        for id, data in pairs(config.items) do
            HLX.Items.Register(id, data)
        end
    end
    if config.wands then
        for id, data in pairs(config.wands) do
            HLX.Magic.RegisterWand(id, data)
        end
    end
    net.Start("hlx_ui")
    net.WriteString("lorepack_load")
    net.WriteString(id)
    net.Broadcast()
    return true
end

function lorepacks.Disable()
    lorepacks.Active = nil
    HLX.Config.EnableLorepack = false
    HLX.Config.ActiveLorepack = ""
    RunConsoleCommand("hlx_lorepack_active", "")
    RunConsoleCommand("hlx_enable_lorepack", "0")
    net.Start("hlx_ui")
    net.WriteString("lorepack_unload")
    net.Broadcast()
end

return lorepacks
