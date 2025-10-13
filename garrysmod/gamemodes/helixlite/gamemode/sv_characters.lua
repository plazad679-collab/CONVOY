--[[
    Sistema de personajes.
]]

HLX.Characters = HLX.Characters or {}
local chars = HLX.Characters

function chars.CreateCommand(ply, args)
    local name = args[2]
    if not name then
        ply:ChatPrint("Debes indicar un nombre")
        return
    end
    local faction = args[3] or "students"
    local year = tonumber(args[4]) or 1
    local wand = args[5] or "basic_wand"
    local success, err = HLX.Persistence.CreateCharacter(ply, {
        name = name,
        faction = faction,
        year = year,
        wand_id = wand
    })
    if not success then
        ply:ChatPrint(err or "Error al crear personaje")
        return
    end
    ply:ChatPrint("Personaje creado")
end

function chars.SelectCommand(ply, args)
    local id = tonumber(args[2] or 0)
    if HLX.Persistence.SelectCharacter(ply, id) then
        ply:ChatPrint("Personaje seleccionado")
    else
        ply:ChatPrint("No se pudo seleccionar")
    end
end

function chars.DeleteCommand(ply, args)
    local id = tonumber(args[2] or 0)
    if id <= 0 then return end
    HLX.Persistence.DeleteCharacter(ply, id)
    ply:ChatPrint("Personaje eliminado")
end

return chars
