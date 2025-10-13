--[[
    Gestión de inventario servidor.
]]

HLX.Inventory = HLX.Inventory or {}
local inventory = HLX.Inventory

inventory.Storage = inventory.Storage or {}

function inventory.Get(ply)
    if not IsValid(ply) then return end
    inventory.Storage[ply] = inventory.Storage[ply] or {}
    return inventory.Storage[ply]
end

function inventory.LoadCharacterInventory(ply, characterID)
    inventory.Storage[ply] = {}
    if not characterID then return end
    local query = string.format("SELECT * FROM hlx_inventories WHERE character_id = %d", tonumber(characterID) or 0)
    local result = HLX.DB.Query(query)
    if istable(result) then
        for _, row in ipairs(result) do
            inventory.Storage[ply][row.item_id] = {
                quantity = tonumber(row.quantity) or 0,
                data = util.JSONToTable(row.data or "{}") or {}
            }
        end
    end
    inventory.Send(ply)
end

local function getInventoryWeight(inv)
    local weight = 0
    for itemID, data in pairs(inv) do
        local item = HLX.Items.Get(itemID)
        if item then
            weight = weight + (item.weight or 0) * (data.quantity or 0)
        end
    end
    return weight
end

function inventory.CanCarry(ply, itemID, quantity)
    quantity = quantity or 1
    local item = HLX.Items.Get(itemID)
    if not item then return false end
    local inv = inventory.Get(ply)
    local weight = getInventoryWeight(inv)
    if item.stack == false and inv[itemID] then
        return false
    end
    if HLX.Config.InventoryMode == "slots" then
        local occupied = table.Count(inv)
        if not inv[itemID] then
            occupied = occupied + 1
        end
        return occupied <= HLX.Config.InventorySlots
    else
        return weight + (item.weight * quantity) <= HLX.Config.InventoryMaxWeight
    end
end

function inventory.Add(ply, itemID, quantity, data)
    quantity = quantity or 1
    if quantity <= 0 then return false end
    local item = HLX.Items.Get(itemID)
    if not item then return false end
    if not inventory.CanCarry(ply, itemID, quantity) then
        return false
    end
    local inv = inventory.Get(ply)
    local entry = inv[itemID]
    if entry and item.stack == false then
        return false
    end
    if entry then
        entry.quantity = entry.quantity + quantity
    else
        inv[itemID] = { quantity = quantity, data = data or {} }
    end
    inventory.Save(ply)
    inventory.Send(ply)
    net.Start("hlx_notifications")
    net.WriteString(string.format("%s x%d", item.name or itemID, quantity))
    net.Send(ply)
    return true
end

function inventory.Remove(ply, itemID, quantity, suppressCallback)
    quantity = quantity or 1
    local inv = inventory.Get(ply)
    local entry = inv[itemID]
    if not entry or entry.quantity < quantity then return false end
    local item = HLX.Items.Get(itemID)
    if not suppressCallback and item and item.OnDrop then
        HLX.Util.SafeCall(item.OnDrop, ply, quantity)
    end
    entry.quantity = entry.quantity - quantity
    if entry.quantity <= 0 then
        inv[itemID] = nil
    end
    inventory.Save(ply)
    inventory.Send(ply)
    return true
end

function inventory.Save(ply)
    local character = ply.CurrentCharacter
    if not character then return end
    HLX.DB.Query(string.format("DELETE FROM hlx_inventories WHERE character_id = %d", tonumber(character.id) or 0))
    for itemID, data in pairs(inventory.Get(ply)) do
        HLX.DB.Query(string.format("INSERT INTO hlx_inventories (character_id, item_id, quantity, data) VALUES (%d, '%s', %d, '%s')",
            tonumber(character.id) or 0, HLX.DB.Escape(itemID), tonumber(data.quantity) or 0, HLX.DB.Escape(util.TableToJSON(data.data or {}))))
    end
end

function inventory.Send(ply)
    local inv = inventory.Get(ply)
    net.Start("hlx_inventory")
    net.WriteUInt(table.Count(inv), 12)
    for itemID, data in pairs(inv) do
        net.WriteString(itemID)
        net.WriteUInt(data.quantity, 16)
    end
    net.Send(ply)
end

hook.Add("PlayerDisconnected", "HLX.InventoryCleanup", function(ply)
    inventory.Storage[ply] = nil
end)

return inventory
