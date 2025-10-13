-- core/player.lua
-- Añade utilidades sobre los jugadores y gestiona eventos comunes.

Garkravall = Garkravall or {}

local PLAYER = FindMetaTable("Player")

function PLAYER:GarkravallGetRank()
    local rank = Garkravall.GetConfig("Ranks." .. self:GetUserGroup())
    return rank or "Alumno"
end

function PLAYER:GarkravallGetHouse()
    local data = Garkravall.GetPlayerData(self)
    return data.house or "Sin Casa"
end

function PLAYER:GarkravallSetHouse(house)
    local data = Garkravall.GetPlayerData(self)
    data.house = house
    Garkravall.BroadcastEvent("PlayerHouseChanged", self, house)
    if SERVER and Garkravall.SendUIData then
        Garkravall.SendUIData(self)
    end
end

function PLAYER:GarkravallAddMoney(amount)
    local data = Garkravall.GetPlayerData(self)
    data.money = (data.money or 0) + amount
    Garkravall.BroadcastEvent("PlayerMoneyChanged", self, data.money)
    if SERVER and Garkravall.SendUIData then
        Garkravall.SendUIData(self)
    end
end

function PLAYER:GarkravallTakeMoney(amount)
    self:GarkravallAddMoney(-math.abs(amount))
end

if SERVER then
    util.AddNetworkString("garkravall_ui_command")
    util.AddNetworkString("garkravall_ui_data")

    local function sendUIData(ply)
        if not IsValid(ply) then return end
        local data = Garkravall.GetPlayerData(ply)
        net.Start("garkravall_ui_data")
        net.WriteTable({
            name = ply:Nick(),
            money = data.money,
            house = data.house,
            level = data.level,
            year = data.year,
            mana = data.mana or 100,
            health = ply:Health(),
            maxHealth = ply:GetMaxHealth(),
            characters = data.characters or {}
        })
        net.Send(ply)
    end

    Garkravall.SendUIData = sendUIData

    hook.Add("PlayerInitialSpawn", "Garkravall_LoadPlayerData", function(ply)
        timer.Simple(0.5, function()
            if not IsValid(ply) then return end
            Garkravall.Database.LoadPlayer(ply)
            ply:GarkravallAddMoney(0)
            sendUIData(ply)
        end)
    end)

    hook.Add("PlayerDisconnected", "Garkravall_SavePlayerData", function(ply)
        Garkravall.Database.SavePlayer(ply)
    end)

    hook.Add("PlayerSay", "Garkravall_CustomChat", function(ply, text, teamChat)
        local prefix = teamChat and "[IC]" or "[OOC]"
        local house = ply:GarkravallGetHouse()
        local formatted = string.format("%s %s (%s): %s", prefix, ply:Nick(), house, text)
        for _, target in ipairs(player.GetAll()) do
            target:ChatPrint(formatted)
        end
        Garkravall.Log(formatted)
        return ""
    end)

    hook.Add("PlayerDeath", "Garkravall_SaveOnDeath", function(ply)
        Garkravall.Database.SavePlayer(ply)
        sendUIData(ply)
    end)

    net.Receive("garkravall_ui_command", function(_, ply)
        local command = net.ReadString()
        if command == "select_house" then
            local house = net.ReadString()
            if Garkravall.Houses then
                Garkravall.Houses:AssignHouse(ply, house)
                sendUIData(ply)
            end
        end
    end)
else
    net.Receive("garkravall_ui_data", function()
        local payload = net.ReadTable()
        if Garkravall.UI and Garkravall.UI.OnData then
            Garkravall.UI.OnData(payload)
        end
    end)
end
