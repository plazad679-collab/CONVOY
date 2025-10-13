--[[
    Manejo de persistencia de jugadores y personajes.
]]

HLX.Persistence = HLX.Persistence or {}
local persistence = HLX.Persistence

function persistence.LoadPlayer(ply)
    if not IsValid(ply) then return end
    local steamID = ply:SteamID64()
    local query = string.format("SELECT * FROM hlx_players WHERE steamid = '%s'", HLX.DB.Escape(steamID))
    local result = HLX.DB.Query(query)

    if not result or istable(result) and #result == 0 then
        HLX.DB.Query(string.format("INSERT INTO hlx_players (steamid, money, role) VALUES ('%s', 0, 'user')", HLX.DB.Escape(steamID)))
        ply:SetNWInt("hlx_money", 0)
        ply:SetNWString("hlx_role", "user")
    else
        local row = istable(result) and result[1] or result
        ply:SetNWInt("hlx_money", tonumber(row.money) or 0)
        ply:SetNWString("hlx_role", row.role or "user")
    end

    persistence.LoadCharacters(ply)
end

function persistence.SavePlayer(ply)
    if not IsValid(ply) then return end
    local steamID = ply:SteamID64()
    local money = ply:GetNWInt("hlx_money", 0)
    local role = ply:GetNWString("hlx_role", "user")
    local query = string.format("REPLACE INTO hlx_players (steamid, money, role) VALUES ('%s', %d, '%s')",
        HLX.DB.Escape(steamID), money, HLX.DB.Escape(role))
    HLX.DB.Query(query)
    if ply.CurrentCharacter then
        HLX.DB.Query(string.format("UPDATE hlx_characters SET mana = %d WHERE id = %d", ply:GetNWInt("hlx_mana", HLX.Config.ManaBase), tonumber(ply.CurrentCharacter.id) or 0))
    end
end

function persistence.LoadCharacters(ply)
    local steamID = ply:SteamID64()
    local query = string.format("SELECT * FROM hlx_characters WHERE steamid = '%s'", HLX.DB.Escape(steamID))
    local result = HLX.DB.Query(query)
    ply.HLXCharacters = istable(result) and result or {}
    if ply.HLXCharacters[1] then
        persistence.SelectCharacter(ply, ply.HLXCharacters[1].id)
    end
end

function persistence.SelectCharacter(ply, characterID)
    if not ply.HLXCharacters then return end
    for _, charData in ipairs(ply.HLXCharacters) do
        if tonumber(charData.id) == tonumber(characterID) then
            ply.CurrentCharacter = charData
            ply:SetNWString("hlx_character_name", charData.name or "")
            ply:SetNWInt("hlx_year", tonumber(charData.year) or 1)
            ply:SetNWString("hlx_faction", charData.faction or "students")
            ply:SetNWString("hlx_wand", charData.wand_id or "basic_wand")
            ply:SetNWInt("hlx_mana", tonumber(charData.mana) or HLX.Config.ManaBase)
            HLX.Inventory.LoadCharacterInventory(ply, charData.id)
            HLX.Hooks.Run("HLX:HouseSorted", ply, charData.faction)
            HLX.Hooks.Run("HLX:WandAssigned", ply, charData.wand_id)
            return true
        end
    end
    return false
end

function persistence.CreateCharacter(ply, data)
    local steamID = ply:SteamID64()
    local name = HLX.Util.SanitizeText(data.name or "")
    if not HLX.Util.ValidateLength(name, 3, 32) then
        return false, "Nombre inválido"
    end

    local query = string.format("INSERT INTO hlx_characters (steamid, name, description, faction, wand_id, year) VALUES ('%s', '%s', '%s', '%s', '%s', %d)",
        HLX.DB.Escape(steamID), HLX.DB.Escape(name), HLX.DB.Escape(data.description or ""), HLX.DB.Escape(data.faction or "students"), HLX.DB.Escape(data.wand_id or "basic_wand"), tonumber(data.year) or 1)
    HLX.DB.Query(query)
    timer.Simple(0.1, function()
        persistence.LoadCharacters(ply)
    end)
    return true
end

function persistence.DeleteCharacter(ply, characterID)
    local steamID = ply:SteamID64()
    HLX.DB.Query(string.format("DELETE FROM hlx_characters WHERE id = %d AND steamid = '%s'", tonumber(characterID) or 0, HLX.DB.Escape(steamID)))
    HLX.DB.Query(string.format("DELETE FROM hlx_inventories WHERE character_id = %d", tonumber(characterID) or 0))
    timer.Simple(0.1, function()
        persistence.LoadCharacters(ply)
    end)
end

return persistence
