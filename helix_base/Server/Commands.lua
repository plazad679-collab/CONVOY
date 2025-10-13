local Helix = Package.GetExports("helix_base").Helix
local Logger = Helix.Logger
local Config = Helix.Config
local CharacterManager = Helix.GetModule("CharacterManager")
local Inventory = Helix.GetModule("Inventory")

local Commands = Helix.RegisterModule("Commands", {})

local function send_message(player, message)
    if Chat and Chat.Send then
        Chat.Send(player, message)
    else
        Events.CallRemote("Chat::AddMessage", player, message)
    end
end

local function split_command(text)
    local args = {}
    for token in string.gmatch(text, "[^%s]+") do
        table.insert(args, token)
    end
    local command = table.remove(args, 1)
    return command, args
end

local function has_prefix(text)
    return text:sub(1, #Config.Chat.CommandPrefix) == Config.Chat.CommandPrefix
end

local function handle_command(player, text)
    local raw_command, args = split_command(text)
    local name = raw_command:sub(#Config.Chat.CommandPrefix + 1):lower()
    local command = Helix.GetCommand(name)
    if not command then
        send_message(player, "Comando desconocido")
        return
    end

    local ok, result = pcall(command.execute, player, args)
    if not ok then
        Logger:error("Error ejecutando comando %s: %s", name, result)
        send_message(player, "Ha ocurrido un error con el comando")
        return
    end

    if type(result) == "string" then
        send_message(player, result)
    end
end

Events.Subscribe("PlayerChat", function(player, text)
    if not text or text == "" then
        return
    end

    if not has_prefix(text) then
        return
    end

    handle_command(player, text)
    return false
end)

Helix.RegisterCommand("ayuda", {
    description = "Muestra los comandos disponibles",
    execute = function(player)
        local available = {}
        for command_name, command_data in pairs(Helix.Commands) do
            table.insert(available, string.format("/%s - %s", command_name, command_data.description or ""))
        end
        table.sort(available)
        return table.concat(available, "\n")
    end
})

Helix.RegisterCommand("pj", {
    description = "Gestiona tus personajes",
    execute = function(player, args)
        local sub = (args[1] or "listar"):lower()

        if sub == "crear" then
            local overrides = {}
            if args[2] then
                overrides.name = table.concat(args, " ", 2)
            end
            local success, result = CharacterManager.Create(player, overrides)
            if success then
                return string.format("Personaje %s creado", result.name)
            else
                return result
            end
        elseif sub == "usar" then
            local character_id = args[2]
            if not character_id then
                return "Debes indicar el ID del personaje"
            end

            local success, result = CharacterManager.Select(player, character_id)
            if success then
                return string.format("Personaje %s seleccionado", result.name)
            else
                return result
            end
        else
            local characters = Helix.Characters[player:GetID()] or {}
            if #characters == 0 then
                return "No tienes personajes creados. Usa /pj crear"
            end

            local lines = {"Tus personajes:"}
            for _, character in ipairs(characters) do
                table.insert(lines, string.format("%s • %s", character.id, character.name))
            end
            return table.concat(lines, "\n")
        end
    end
})

Helix.RegisterCommand("inventario", {
    description = "Muestra el inventario actual",
    execute = function(player)
        local inventory = Inventory.List(player)
        if #inventory == 0 then
            return "Tu inventario está vacío"
        end

        local lines = {"Inventario:"}
        for _, item in ipairs(inventory) do
            table.insert(lines, string.format("%s x%d", item.label or item.name, item.quantity or 1))
        end
        return table.concat(lines, "\n")
    end
})

return Commands
