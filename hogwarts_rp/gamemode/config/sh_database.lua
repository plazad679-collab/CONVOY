Hogwarts.Config.Database = {
    enabled = false,
    module = "mysqloo",
    hostname = "127.0.0.1",
    port = 3306,
    username = "hogwarts",
    password = "supersecret",
    database = "hogwarts",
    characters_table = "hogwarts_characters",
    spells_table = "hogwarts_spells"
}

return Hogwarts.Config.Database
