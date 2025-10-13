-- core/database.lua
-- Maneja la persistencia de datos para GarkravallRP.

Garkravall = Garkravall or {}

local config = Garkravall.GetConfig and Garkravall.GetConfig("Database") or nil

local DATABASE = {
    Connected = false,
    Driver = "sqlite"
}

local function setupSQLite()
    DATABASE.Connected = true
    Garkravall.Log("Base de datos SQLite lista.")
end

local function setupMySQL()
    if not mysqloo then
        Garkravall.Log("mysqloo no está disponible, usando SQLite.")
        setupSQLite()
        return
    end

    local mysqlConfig = config.mysql
    DATABASE.Connection = mysqloo.connect(mysqlConfig.host, mysqlConfig.username, mysqlConfig.password, mysqlConfig.database, mysqlConfig.port)

    function DATABASE.Connection:onConnected()
        DATABASE.Connected = true
        Garkravall.Log("Conectado a MySQL correctamente.")
    end

    function DATABASE.Connection:onConnectionFailed(err)
        Garkravall.Log("Fallo al conectar a MySQL: " .. err)
        setupSQLite()
    end

    DATABASE.Connection:connect()
end

function DATABASE.Initialize()
    config = Garkravall.GetConfig("Database")
    DATABASE.Driver = config.driver

    if DATABASE.Driver == "mysql" then
        setupMySQL()
    else
        setupSQLite()
    end

    if SERVER then
        sql.Query([[CREATE TABLE IF NOT EXISTS garkravall_players (
            steamid TEXT PRIMARY KEY,
            name TEXT,
            house TEXT,
            year INTEGER,
            level INTEGER,
            wand TEXT,
            money INTEGER,
            experience INTEGER,
            reputation INTEGER
        )]])
    end
end

function DATABASE.SavePlayer(ply)
    if not IsValid(ply) then return end

    local data = Garkravall.GetPlayerData(ply)
    local steamID64 = ply:SteamID64() or "npc" .. ply:EntIndex()

    sql.Query(string.format([[REPLACE INTO garkravall_players (steamid, name, house, year, level, wand, money, experience, reputation)
        VALUES ("%s", "%s", "%s", %d, %d, "%s", %d, %d, %d)]],
        steamID64,
        sql.SQLStr(ply:Nick(), true),
        sql.SQLStr(data.house or ""),
        tonumber(data.year or 1) or 1,
        tonumber(data.level or 1) or 1,
        sql.SQLStr(data.wand or ""),
        tonumber(data.money or 0) or 0,
        tonumber(data.experience or 0) or 0,
        tonumber(data.reputation or 0) or 0
    ))
end

function DATABASE.LoadPlayer(ply)
    if not IsValid(ply) then return end

    local steamID64 = ply:SteamID64() or "npc" .. ply:EntIndex()
    local result = sql.QueryRow("SELECT * FROM garkravall_players WHERE steamid = '" .. steamID64 .. "'")

    local data = Garkravall.GetPlayerData(ply)

    if result then
        data.house = result.house
        data.year = tonumber(result.year) or 1
        data.level = tonumber(result.level) or 1
        data.wand = result.wand
        data.money = tonumber(result.money) or data.money
        data.experience = tonumber(result.experience) or 0
        data.reputation = tonumber(result.reputation) or 0
    end

    Garkravall.BroadcastEvent("PlayerDataLoaded", ply, data)
end

Garkravall.Database = DATABASE
