local Helix = Package.GetExports("helix_base").Helix
local Logger = Helix.Logger
local Config = Helix.Config

local Inventory = Helix.RegisterModule("Inventory", {})

local function get_inventory(player)
    return Helix.Items[player:GetID()] or {}
end

function Inventory.List(player)
    return get_inventory(player)
end

function Inventory.Add(player, item)
    local inventory = get_inventory(player)
    if #inventory >= Config.Inventory.Slots then
        return false, "No tienes espacio suficiente"
    end

    table.insert(inventory, item)
    Helix.Items[player:GetID()] = inventory
    Logger:info("%s recibió %s", player:GetName(), item.label or item.name)

    Events.CallRemote(Config.Networking.SyncInventoryEvent, player, inventory)
    return true, inventory
end

function Inventory.Remove(player, item_name, quantity)
    local inventory = get_inventory(player)
    quantity = quantity or 1

    for index = #inventory, 1, -1 do
        local entry = inventory[index]
        if entry.name == item_name then
            if entry.quantity > quantity then
                entry.quantity = entry.quantity - quantity
                quantity = 0
            else
                quantity = quantity - entry.quantity
                table.remove(inventory, index)
            end

            if quantity <= 0 then
                break
            end
        end
    end

    Helix.Items[player:GetID()] = inventory
    Events.CallRemote(Config.Networking.SyncInventoryEvent, player, inventory)
    return true, inventory
end

return Inventory
