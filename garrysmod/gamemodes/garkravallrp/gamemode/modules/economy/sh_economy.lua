-- sh_economy.lua
-- Control del dinero y las tiendas en GarkravallRP.

local MODULE = {}
MODULE.Shops = {}

function MODULE:Init()
    Garkravall.Economy = self
    if SERVER then
        timer.Create("Garkravall_SalaryTimer", Garkravall.GetConfig("Economy.salaryInterval", 600), 0, function()
            for _, ply in ipairs(player.GetAll()) do
                local rank = ply:GarkravallGetRank()
                local amount = Garkravall.GetConfig("Economy.salaryAmounts." .. rank, 25)
                ply:GarkravallAddMoney(amount)
                ply:ChatPrint("Has recibido tu salario de " .. amount .. " galeones.")
            end
        end)
    end
end

function MODULE:RegisterShop(identifier, data)
    self.Shops[identifier] = data
end

function MODULE:BuyItem(ply, shopId, itemId)
    local shop = self.Shops[shopId]
    if not shop then
        ply:ChatPrint("La tienda no existe.")
        return
    end

    local item = shop.items[itemId]
    if not item then
        ply:ChatPrint("El objeto no está disponible.")
        return
    end

    local data = Garkravall.GetPlayerData(ply)
    if (data.money or 0) < item.price then
        ply:ChatPrint("No tienes suficientes galeones.")
        return
    end

    ply:GarkravallTakeMoney(item.price)
    Garkravall.Inventory:AddItem(ply, item)
    ply:ChatPrint("Has comprado " .. item.name .. ".")
end

Garkravall.RegisterModule("economy", MODULE)
