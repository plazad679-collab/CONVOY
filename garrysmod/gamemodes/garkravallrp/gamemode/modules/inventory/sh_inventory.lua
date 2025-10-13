-- sh_inventory.lua
-- Implementa un inventario simple para los jugadores.

local MODULE = {}
MODULE.Storage = {}

function MODULE:Init()
    Garkravall.Inventory = self
end

function MODULE:GetInventory(ply)
    local data = Garkravall.GetPlayerData(ply)
    data.inventory = data.inventory or {}
    return data.inventory
end

function MODULE:AddItem(ply, item)
    local inventory = self:GetInventory(ply)
    table.insert(inventory, item)
    Garkravall.BroadcastEvent("InventoryUpdated", ply, inventory)
    if SERVER and Garkravall.SendUIData then
        Garkravall.SendUIData(ply)
    end
end

function MODULE:RemoveItem(ply, itemName)
    local inventory = self:GetInventory(ply)
    for index, item in ipairs(inventory) do
        if item.name == itemName then
            table.remove(inventory, index)
            break
        end
    end
    Garkravall.BroadcastEvent("InventoryUpdated", ply, inventory)
    if SERVER and Garkravall.SendUIData then
        Garkravall.SendUIData(ply)
    end
end

function MODULE:HasItem(ply, itemName)
    local inventory = self:GetInventory(ply)
    for _, item in ipairs(inventory) do
        if item.name == itemName then
            return true
        end
    end
    return false
end

Garkravall.RegisterModule("inventory", MODULE)
