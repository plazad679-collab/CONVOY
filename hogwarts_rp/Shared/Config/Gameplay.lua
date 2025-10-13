local GameplayConfig = {
    starting_house = "SortingPending",
    starting_year = 1,
    max_year = 7,
    max_characters = 3,
    default_currency = {
        galeons = 25,
        sickles = 12,
        knuts = 29
    },
    spell_slots = {
        first_year = 6,
        seventh_year = 16
    },
    cooldowns = {
        basic_spell = 1.5,
        advanced_spell = 4.0,
        ultimate_spell = 12.0
    },
    fatigue = {
        enabled = true,
        regen_rate = 2.0,
        regen_delay = 5.0
    },
    houses = {
        "Gryffindor",
        "Hufflepuff",
        "Ravenclaw",
        "Slytherin"
    }
}

return GameplayConfig
