--[[
    Registro y ejecución de comandos de chat y consola.
]]

HLX.Commands = HLX.Commands or {}
local commands = HLX.Commands

commands.Stored = commands.Stored or {}
commands.RateLimit = {}

local function parseArguments(text)
    local args = {}
    for word in string.gmatch(text, "[^\s]+") do
        table.insert(args, word)
    end
    return args
end

function commands.Register(name, data)
    name = string.lower(name)
    data.name = name
    commands.Stored[name] = data

    if data.concommand then
        concommand.Add(data.concommand, function(ply, _, arguments)
            commands.Execute(ply, name, arguments)
        end)
    end
end

function commands.Execute(ply, name, arguments)
    name = string.lower(name)
    local command = commands.Stored[name]
    if not command then return end

    if command.permission and not HLX.Permissions.HasPerm(ply, command.permission) then
        ply:ChatPrint(HLX.Translate("command_no_permission"))
        return
    end

    local key = ply:SteamID64() .. name
    local now = CurTime()
    commands.RateLimit[key] = commands.RateLimit[key] or 0
    if now < commands.RateLimit[key] then
        ply:ChatPrint("Comando en cooldown")
        return
    end
    commands.RateLimit[key] = now + (command.cooldown or 0.5)

    HLX.Util.SafeCall(command.run, ply, arguments)
end

hook.Add("PlayerSay", "HLX.ChatCommands", function(ply, text)
    local prefix = HLX.Config.CommandPrefix or "/"
    if not string.StartWith(text, prefix) then return end
    local arguments = parseArguments(text)
    if #arguments == 0 then return end
    local commandName = string.sub(arguments[1], #prefix + 1)
    if commandName == "" then return end
    commands.Execute(ply, commandName, arguments)
    return ""
end)

-- Comandos por defecto
commands.Register("inv", {
    run = function(ply)
        HLX.Inventory.Send(ply)
        net.Start("hlx_ui")
        net.WriteString("inventory_toggle")
        net.Send(ply)
    end
})

commands.Register("use", {
    run = function(ply, args)
        local itemID = args[2]
        if not itemID then return end
        local inv = HLX.Inventory.Get(ply)
        local entry = inv[itemID]
        if not entry then return end
        local item = HLX.Items.Get(itemID)
        if not item then return end
        if item.equip and item.OnEquip then
            HLX.Util.SafeCall(item.OnEquip, ply, entry.data)
        elseif item.OnUse then
            HLX.Util.SafeCall(item.OnUse, ply, entry.data)
            HLX.Inventory.Remove(ply, itemID, 1, true)
        end
    end
})

commands.Register("drop", {
    run = function(ply, args)
        local itemID = args[2]
        local amount = tonumber(args[3]) or 1
        HLX.Inventory.Remove(ply, itemID, amount)
    end
})

commands.Register("cast", {
    cooldown = 0.2,
    run = function(ply, args)
        HLX.Spells.Command(ply, args)
    end
})

commands.Register("charcreate", {
    run = function(ply, args)
        HLX.Characters.CreateCommand(ply, args)
    end
})

commands.Register("charselect", {
    run = function(ply, args)
        HLX.Characters.SelectCommand(ply, args)
    end
})

commands.Register("chardelete", {
    run = function(ply, args)
        HLX.Characters.DeleteCommand(ply, args)
    end
})

commands.Register("giveitem", {
    permission = "hlx.manage",
    run = function(ply, args)
        local targetName = args[2] or "me"
        local itemID = args[3]
        local amount = tonumber(args[4]) or 1
        if not itemID then return end
        local target = ply
        if targetName ~= "me" then
            for _, v in ipairs(player.GetAll()) do
                if string.find(string.lower(v:Nick()), string.lower(targetName), 1, true) or v:SteamID64() == targetName then
                    target = v
                    break
                end
            end
        end
        if not IsValid(target) then return end
        if not HLX.Items.Get(itemID) then return end
        HLX.Inventory.Add(target, itemID, amount)
    end
})

commands.Register("setfaction", {
    permission = "hlx.manage",
    run = function(ply, args)
        local targetName = args[2] or "me"
        local faction = args[3]
        if not faction then return end
        local target = ply
        if targetName ~= "me" then
            for _, v in ipairs(player.GetAll()) do
                if string.find(string.lower(v:Nick()), string.lower(targetName), 1, true) or v:SteamID64() == targetName then
                    target = v
                    break
                end
            end
        end
        if not IsValid(target) then return end
        HLX.Factions.Apply(target, faction)
    end
})

commands.Register("setmoney", {
    permission = "hlx.manage",
    run = function(ply, args)
        local targetName = args[2] or "me"
        local amount = tonumber(args[3]) or 0
        local target = ply
        if targetName ~= "me" then
            for _, v in ipairs(player.GetAll()) do
                if string.find(string.lower(v:Nick()), string.lower(targetName), 1, true) or v:SteamID64() == targetName then
                    target = v
                    break
                end
            end
        end
        if not IsValid(target) then return end
        target:SetNWInt("hlx_money", amount)
        HLX.Persistence.SavePlayer(target)
    end
})

commands.Register("lorepack", {
    permission = "hlx.manage",
    run = function(ply, args)
        local action = string.lower(args[2] or "")
        local pack = string.lower(args[3] or "")
        if action == "enable" then
            if HLX.Lorepacks.Enable(pack) then
                ply:ChatPrint(HLX.Translate("lorepack_enabled"))
            else
                ply:ChatPrint("Lorepack no encontrado")
            end
        elseif action == "disable" then
            HLX.Lorepacks.Disable(pack)
            ply:ChatPrint(HLX.Translate("lorepack_disabled"))
        end
    end
})

return commands
