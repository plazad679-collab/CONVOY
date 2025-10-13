local Logger = Package.Require("Shared/Modules/Logger.lua")
local GameplayConfig = Package.Require("Shared/Config/Gameplay.lua")
local TableUtils = Package.Require("Shared/Modules/TableUtils.lua")
local MySQL = Package.Require("Server/Database/MySQL.lua")
local HouseService = Package.Require("Server/Services/HouseService.lua")
local SpellsData = Package.Require("Shared/Data/Spells.lua")

local CharacterService = {}
CharacterService.cache = {}
CharacterService.spells_index = TableUtils.index_by(SpellsData, "id")

local function default_stats()
    return {
        courage = 10,
        wisdom = 10,
        ambition = 10,
        loyalty = 10,
        fatigue = 0,
        mana = 100,
        health = 100
    }
end

local function default_schedule()
    return {
        classes = {},
        detentions = {},
        quidditch = {}
    }
end

local function default_reputation()
    return {
        houses = {
            Gryffindor = 0,
            Hufflepuff = 0,
            Ravenclaw = 0,
            Slytherin = 0
        },
        professors = {}
    }
end

local function default_inventory()
    return {
        wand = {
            wood = "roble",
            core = "pluma de fénix",
            length = 11.0
        },
        items = {
            { id = "uniforme_hogwarts", quantity = 1 },
            { id = "libro_hechizos", quantity = 1 }
        }
    }
end

function CharacterService:get_character(id)
    if self.cache[id] then
        return self.cache[id]
    end

    local rows = MySQL:select("SELECT * FROM hogwarts_characters WHERE id = ?", { id })
    if not rows or not rows[1] then
        return nil
    end

    local character = rows[1]
    character.inventory = json.decode(character.inventory)
    character.reputation = json.decode(character.reputation)
    character.schedule = json.decode(character.schedule)
    character.stats = json.decode(character.stats)

    self.cache[id] = character
    return character
end

function CharacterService:get_player_characters(player_id)
    local rows = MySQL:select("SELECT * FROM hogwarts_characters WHERE player_id = ?", { player_id }) or {}

    for _, character in ipairs(rows) do
        character.inventory = json.decode(character.inventory)
        character.reputation = json.decode(character.reputation)
        character.schedule = json.decode(character.schedule)
        character.stats = json.decode(character.stats)
        self.cache[character.id] = character
    end

    return rows
end

function CharacterService:create(player_id, data)
    local character_data = {
        first_name = data.first_name,
        last_name = data.last_name,
        house = data.house or HouseService:assign_by_traits(data.traits),
        year = data.year or GameplayConfig.starting_year,
        blood_status = data.blood_status or "half_blood",
        wand_wood = data.wand and data.wand.wood or default_inventory().wand.wood,
        wand_core = data.wand and data.wand.core or default_inventory().wand.core,
        wand_length = data.wand and data.wand.length or default_inventory().wand.length,
        patronus = data.patronus,
        inventory = data.inventory or default_inventory(),
        currency_galeons = data.currency and data.currency.galeons or GameplayConfig.default_currency.galeons,
        currency_sickles = data.currency and data.currency.sickles or GameplayConfig.default_currency.sickles,
        currency_knuts = data.currency and data.currency.knuts or GameplayConfig.default_currency.knuts,
        reputation = data.reputation or default_reputation(),
        schedule = data.schedule or default_schedule(),
        stats = data.stats or default_stats()
    }

    local result, err = MySQL:execute([[INSERT INTO hogwarts_characters (
        player_id, first_name, last_name, house, year, blood_status, wand_wood, wand_core, wand_length,
        patronus, inventory, currency_galeons, currency_sickles, currency_knuts, reputation, schedule, stats
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]], {
        player_id,
        character_data.first_name,
        character_data.last_name,
        character_data.house,
        character_data.year,
        character_data.blood_status,
        character_data.wand_wood,
        character_data.wand_core,
        character_data.wand_length,
        character_data.patronus,
        json.encode(character_data.inventory),
        character_data.currency_galeons,
        character_data.currency_sickles,
        character_data.currency_knuts,
        json.encode(character_data.reputation),
        json.encode(character_data.schedule),
        json.encode(character_data.stats)
    })

    if not result then
        return nil, err
    end

    character_data.id = result:LastInsertId()
    character_data.player_id = player_id

    self.cache[character_data.id] = character_data
    Logger:info("Creado personaje %s %s (#%d) para jugador %d", character_data.first_name, character_data.last_name, character_data.id, player_id)

    for _, spell in ipairs(SpellsData) do
        if spell.year <= character_data.year then
            MySQL:execute([[INSERT INTO hogwarts_spells (character_id, spell_id, proficiency)
                VALUES (?, ?, 'novice')]], { character_data.id, spell.id })
        end
    end

    return character_data
end

function CharacterService:update(character_id, updates)
    local character = self:get_character(character_id)
    if not character then
        return nil, "character_not_found"
    end

    local merged = TableUtils.merge(character, updates)

    MySQL:execute([[UPDATE hogwarts_characters SET
        first_name = ?, last_name = ?, house = ?, year = ?, blood_status = ?, wand_wood = ?, wand_core = ?, wand_length = ?, patronus = ?,
        inventory = ?, currency_galeons = ?, currency_sickles = ?, currency_knuts = ?, reputation = ?, schedule = ?, stats = ?
        WHERE id = ?]], {
        merged.first_name,
        merged.last_name,
        merged.house,
        merged.year,
        merged.blood_status,
        merged.wand_wood,
        merged.wand_core,
        merged.wand_length,
        merged.patronus,
        json.encode(merged.inventory),
        merged.currency_galeons,
        merged.currency_sickles,
        merged.currency_knuts,
        json.encode(merged.reputation),
        json.encode(merged.schedule),
        json.encode(merged.stats),
        character_id
    })

    self.cache[character_id] = merged
    return merged
end

function CharacterService:grant_spell(character_id, spell_id)
    local spell = self.spells_index[spell_id]
    if not spell then
        return nil, "spell_not_found"
    end

    MySQL:execute([[INSERT INTO hogwarts_spells (character_id, spell_id, proficiency)
        VALUES (?, ?, 'novice')
        ON DUPLICATE KEY UPDATE proficiency = VALUES(proficiency)]], {
        character_id,
        spell_id
    })

    Logger:info("Hechizo %s concedido a personaje %d", spell_id, character_id)
    return true
end

return CharacterService
