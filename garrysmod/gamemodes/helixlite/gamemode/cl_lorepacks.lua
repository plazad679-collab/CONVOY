--[[
    Manejo cliente de lorepacks.
]]

HLX.Lorepacks = HLX.Lorepacks or {}

function HLX.Lorepacks.LoadClient(id)
    if not id or id == "" then return end
    local path = "helixlite/gamemode/lorepacks/" .. id .. "/sh_lore_config.lua"
    if not file.Exists(path, "LUA") then return end
    local config = include(path)
    if not config then return end
    if config.spells then
        for spellID, data in pairs(config.spells) do
            HLX.Magic.RegisterSpell(spellID, data)
        end
    end
    if config.wands then
        for wandID, data in pairs(config.wands) do
            HLX.Magic.RegisterWand(wandID, data)
        end
    end
    if config.factions and HLX.CharacterCreator then
        HLX.CharacterCreator.Houses = {}
        for id, data in pairs(config.factions) do
            HLX.Factions.Register(id, data)
            HLX.CharacterCreator.Houses[id] = data
        end
    end
    if HLX.CharacterCreator and HLX.CharacterCreator.Initialize then
        HLX.CharacterCreator.Initialize()
    end
end
