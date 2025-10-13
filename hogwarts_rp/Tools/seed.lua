local Logger = Package.Require("Shared/Modules/Logger.lua")
local DatabaseConfig = Package.Require("Shared/Config/Database.lua")
local MySQL = Package.Require("Server/Database/MySQL.lua")
local Houses = Package.Require("Shared/Data/Houses.lua")
local Spells = Package.Require("Shared/Data/Spells.lua")

local Seeder = {}

function Seeder:Run()
    Logger:info("Iniciando seed de datos Hogwarts RP")

    MySQL:connect(DatabaseConfig.connection)

    for id, house in pairs(Houses) do
        MySQL:execute([[INSERT INTO hogwarts_lore_houses (id, founder, ghost, relic, colors, traits)
            VALUES (?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE founder = VALUES(founder), ghost = VALUES(ghost), relic = VALUES(relic), colors = VALUES(colors), traits = VALUES(traits)
        ]], {
            id,
            house.founder,
            house.ghost,
            house.relic,
            json.encode(house.colors),
            json.encode(house.traits)
        })
    end

    for _, spell in ipairs(Spells) do
        MySQL:execute([[INSERT INTO hogwarts_lore_spells (id, name, incantation, difficulty, min_year, cooldown, description, tags)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE name = VALUES(name), incantation = VALUES(incantation), difficulty = VALUES(difficulty), min_year = VALUES(min_year), cooldown = VALUES(cooldown), description = VALUES(description), tags = VALUES(tags)
        ]], {
            spell.id,
            spell.name,
            spell.incantation,
            spell.difficulty,
            spell.year,
            spell.cooldown,
            spell.description,
            json.encode(spell.tags)
        })
    end

    Logger:info("Seed completado")
end

return Seeder
