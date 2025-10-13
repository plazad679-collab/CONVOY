-- sh_characters.lua
-- Manejo de personajes, selección y progreso.

local MODULE = {}
MODULE.Characters = {}

function MODULE:Init()
    Garkravall.Characters = self
    if SERVER then
        util.AddNetworkString("garkravall_select_character")
    else
        Garkravall.UI = Garkravall.UI or {}
    end
end

function MODULE:GetCharacters(ply)
    local data = Garkravall.GetPlayerData(ply)
    data.characters = data.characters or {}
    return data.characters
end

function MODULE:AddCharacter(ply, info)
    local characters = self:GetCharacters(ply)
    table.insert(characters, info)
    Garkravall.BroadcastEvent("CharacterCreated", ply, info)
    if SERVER and Garkravall.SendUIData then
        Garkravall.SendUIData(ply)
    end
end

function MODULE:SelectCharacter(ply, index)
    local characters = self:GetCharacters(ply)
    local character = characters[index]
    if not character then
        if SERVER then ply:ChatPrint("El personaje seleccionado no existe.") end
        return
    end

    local data = Garkravall.GetPlayerData(ply)
    data.house = character.house
    data.year = character.year
    data.level = character.level
    data.wand = character.wand

    Garkravall.Database.SavePlayer(ply)
    Garkravall.BroadcastEvent("CharacterSelected", ply, character)
    if SERVER and Garkravall.SendUIData then
        Garkravall.SendUIData(ply)
    end
end

if SERVER then
    net.Receive("garkravall_select_character", function(_, ply)
        local index = net.ReadUInt(8)
        MODULE:SelectCharacter(ply, index)
    end)
else
    Garkravall.UI = Garkravall.UI or {}
    function Garkravall.UI.SelectCharacter(index)
        net.Start("garkravall_select_character")
        net.WriteUInt(index, 8)
        net.SendToServer()
    end
end

Garkravall.RegisterModule("characters", MODULE)
