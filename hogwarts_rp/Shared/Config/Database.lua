local DatabaseConfig = {
    connection = {
        host = os.getenv("HOGWARTS_DB_HOST") or "127.0.0.1",
        port = tonumber(os.getenv("HOGWARTS_DB_PORT") or "3306"),
        username = os.getenv("HOGWARTS_DB_USER") or "hogwarts",
        password = os.getenv("HOGWARTS_DB_PASSWORD") or "secreta",
        database = os.getenv("HOGWARTS_DB_NAME") or "hogwarts_rp",
        charset = "utf8mb4",
        max_pool_size = tonumber(os.getenv("HOGWARTS_DB_POOL") or "10"),
        min_pool_size = 1,
        timeout = 30
    },
    options = {
        sync_schema_on_start = true,
        enable_query_logging = true,
        slow_query_threshold = 0.25
    }
}

return DatabaseConfig
