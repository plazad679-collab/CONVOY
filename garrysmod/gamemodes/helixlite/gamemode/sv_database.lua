--[[
    Capa de base de datos con soporte SQLite / tmysql4.
]]

HLX.DB = HLX.DB or {}
local DB = HLX.DB

DB.Connected = false
DB.UseMySQL = false
DB.Connection = nil

function DB.Connect()
    if DB.Connected then return end

    if tmysql and tmysql.initialize and HLX.Config.MySQL then
        local cfg = HLX.Config.MySQL
        DB.Connection, DB.Error = tmysql.initialize(cfg.host, cfg.user, cfg.password, cfg.database, cfg.port, nil, cfg.socket)
        if DB.Connection then
            DB.UseMySQL = true
            DB.Connected = true
            HLX.Logging.Info("Conectado a MySQL mediante tmysql4")
            return
        else
            HLX.Logging.Warn("Fallo conectando a MySQL, usando SQLite: " .. tostring(DB.Error))
        end
    end

    DB.UseMySQL = false
    DB.Connected = true
    HLX.Logging.Info("Usando SQLite interno")
end

function DB.Escape(str)
    if DB.UseMySQL and DB.Connection then
        return DB.Connection:Escape(str)
    end
    return sql.SQLStr(str, true)
end

function DB.Query(query, callback)
    if DB.UseMySQL and DB.Connection then
        return DB.Connection:Query(query, function(result)
            if callback then callback(result and result[1] or result, result and result[2]) end
        end)
    end

    local result = sql.Query(query)
    if callback then callback(result, sql.LastError()) end
    return result, sql.LastError()
end

local schemaStatements = {
    [[CREATE TABLE IF NOT EXISTS hlx_players (
        steamid TEXT PRIMARY KEY,
        money INTEGER DEFAULT 0,
        role TEXT DEFAULT 'user'
    )]],
    [[CREATE TABLE IF NOT EXISTS hlx_characters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        steamid TEXT,
        name TEXT,
        description TEXT,
        faction TEXT,
        wand_id TEXT,
        year INTEGER,
        mana INTEGER DEFAULT 100,
        spell_level INTEGER DEFAULT 1,
        wand_affinity REAL DEFAULT 0,
        FOREIGN KEY(steamid) REFERENCES hlx_players(steamid)
    )]],
    [[CREATE TABLE IF NOT EXISTS hlx_inventories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        character_id INTEGER,
        item_id TEXT,
        quantity INTEGER,
        data TEXT
    )]],
    [[CREATE TABLE IF NOT EXISTS hlx_items (
        id TEXT PRIMARY KEY,
        name TEXT,
        weight REAL,
        stack INTEGER
    )]],
    [[CREATE TABLE IF NOT EXISTS hlx_factions (
        id TEXT PRIMARY KEY,
        name TEXT,
        color TEXT,
        permissions TEXT
    )]],
    [[CREATE TABLE IF NOT EXISTS hlx_magic_spells (
        id TEXT PRIMARY KEY,
        name TEXT,
        school TEXT,
        cooldown REAL,
        mana_cost INTEGER
    )]],
    [[CREATE TABLE IF NOT EXISTS hlx_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        actor TEXT,
        target TEXT,
        message TEXT,
        created_at INTEGER
    )]]
}

function DB.InitSchema()
    for _, statement in ipairs(schemaStatements) do
        if DB.UseMySQL then
            DB.Query(statement)
        else
            sql.Query(statement)
            if sql.LastError() then
                HLX.Logging.Error("Error creando tabla: " .. sql.LastError())
            end
        end
    end
end

return DB
