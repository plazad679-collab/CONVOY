local Logger = Package.Require("Shared/Modules/Logger.lua")
local DatabaseConfig = Package.Require("Shared/Config/Database.lua")

local MySQL = {}
MySQL._pool = nil
MySQL._config = nil

local function ensure_driver()
    if MySQL._driver then
        return
    end

    if MySQLAsync then
        MySQL._driver = MySQLAsync
    elseif MySQLModule then
        MySQL._driver = MySQLModule
    else
        error("No se encontró driver de MySQL compatible. Asegúrate de cargar MySQLAsync.")
    end
end

function MySQL:connect(config)
    ensure_driver()
    self._config = config or DatabaseConfig.connection

    if self._pool then
        return self._pool
    end

    Logger:info("Conectando a MySQL %s:%d base %s", self._config.host, self._config.port, self._config.database)

    self._pool = self._driver.Connect({
        host = self._config.host,
        port = self._config.port,
        username = self._config.username,
        password = self._config.password,
        database = self._config.database,
        charset = self._config.charset,
        max_pool_size = self._config.max_pool_size,
        min_pool_size = self._config.min_pool_size,
        timeout = self._config.timeout
    })

    if not self._pool then
        error("No se pudo establecer conexión con MySQL")
    end

    return self._pool
end

function MySQL:execute(query, parameters)
    if not self._pool then
        self:connect()
    end

    local start_time = os.clock()
    local result, err = self._pool:Execute(query, parameters or {})
    if not result then
        Logger:error("MySQL execute error: %s", err or "desconocido")
        return nil, err
    end

    local elapsed = os.clock() - start_time
    if DatabaseConfig.options.enable_query_logging then
        if elapsed > (DatabaseConfig.options.slow_query_threshold or math.huge) then
            Logger:warn("Consulta lenta (%.2f s): %s", elapsed, query)
        else
            Logger:debug("Consulta ejecutada en %.2f s", elapsed)
        end
    end

    return result
end

function MySQL:select(query, parameters)
    local result, err = self:execute(query, parameters)
    if not result then
        return nil, err
    end

    return result:FetchAll()
end

function MySQL:transaction(callback)
    if not self._pool then
        self:connect()
    end

    local transaction = self._pool:BeginTransaction()
    local ok, response = pcall(callback, transaction)
    if not ok then
        transaction:Rollback()
        Logger:error("Transacción revertida: %s", response)
        return false, response
    end

    local commit_ok, commit_err = transaction:Commit()
    if not commit_ok then
        Logger:error("Error al confirmar transacción: %s", commit_err)
        return false, commit_err
    end

    return true, response
end

return MySQL
