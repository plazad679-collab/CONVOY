local Logger = Package.Require("Shared/Modules/Logger.lua")
local EventBus = Package.Require("Shared/Modules/EventBus.lua")
local DatabaseConfig = Package.Require("Shared/Config/Database.lua")
local GameplayConfig = Package.Require("Shared/Config/Gameplay.lua")
local Houses = Package.Require("Shared/Data/Houses.lua")
local Spells = Package.Require("Shared/Data/Spells.lua")
local Classes = Package.Require("Shared/Data/Classes.lua")
local Locations = Package.Require("Shared/Data/Locations.lua")
local TableUtils = Package.Require("Shared/Modules/TableUtils.lua")
local MySQL = Package.Require("Server/Database/MySQL.lua")

local Hogwarts = Package.GetExports("hogwarts_rp").Hogwarts

Hogwarts.Config.Database = DatabaseConfig
Hogwarts.Config.Gameplay = GameplayConfig
Hogwarts.Data.Houses = Houses
Hogwarts.Data.Spells = Spells
Hogwarts.Data.Classes = Classes
Hogwarts.Data.Locations = Locations
Hogwarts.Modules.Logger = Logger
Hogwarts.Modules.EventBus = EventBus
Hogwarts.Modules.TableUtils = TableUtils
Hogwarts.Database = MySQL

Logger:info("Hogwarts RP versión %s inicializando (servidor)", Hogwarts.Version)

MySQL:connect(DatabaseConfig.connection)

if DatabaseConfig.options.sync_schema_on_start then
    local schema_sql = Package.ReadFile("Shared/Schema/migrations.sql")
    if schema_sql then
        Logger:info("Ejecutando migraciones de esquema")
        for statement in string.gmatch(schema_sql, "(.-);%s*\n") do
            local trimmed = statement:gsub("^%s+", ""):gsub("%s+$", "")
            if trimmed ~= "" then
                local ok, err = MySQL:execute(trimmed)
                if not ok then
                    Logger:error("Fallo al ejecutar migración: %s", err or "desconocido")
                end
            end
        end
    else
        Logger:warn("No se pudo leer el archivo de migraciones")
    end
end

Hogwarts.Services.House = Package.Require("Server/Services/HouseService.lua")
Hogwarts.Services.Character = Package.Require("Server/Services/CharacterService.lua")
Hogwarts.Services.Spell = Package.Require("Server/Services/SpellService.lua")
Hogwarts.Services.Economy = Package.Require("Server/Services/EconomyService.lua")
Hogwarts.Services.Schedule = Package.Require("Server/Services/ScheduleService.lua")
Hogwarts.Services.Lore = Package.Require("Server/Services/LoreService.lua")

Hogwarts.Controllers.Character = Package.Require("Server/Controllers/CharacterController.lua")
Hogwarts.Controllers.Spell = Package.Require("Server/Controllers/SpellController.lua")

Logger:info("Servicios y controladores cargados")

return Hogwarts
