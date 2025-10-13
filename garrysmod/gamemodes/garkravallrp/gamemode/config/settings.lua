-- settings.lua
-- Configuración principal del gamemode GarkravallRP.

local CONFIG = {}

-- Configuración de base de datos.
CONFIG.Database = {
    driver = "sqlite", -- Opciones: "sqlite" o "mysql"
    sqlite = {
        path = "garkravallrp_data.db"
    },
    mysql = {
        host = "127.0.0.1",
        username = "garkravall",
        password = "contraseña_segura",
        database = "garkravallrp",
        port = 3306
    }
}

-- Configuración de permisos base.
CONFIG.Ranks = {
    ["superadmin"] = "Admin",
    ["admin"] = "Admin",
    ["moderator"] = "Profesor",
    ["user"] = "Alumno"
}

-- Configuración de interfaz.
CONFIG.UI = {
    themeColor = "#c9a86a",
    accentColor = "#2f4f4f"
}

-- Configuración de economía.
CONFIG.Economy = {
    startingMoney = 150,
    salaryInterval = 600,
    salaryAmounts = {
        Admin = 50,
        Profesor = 40,
        Alumno = 25
    }
}

return CONFIG
