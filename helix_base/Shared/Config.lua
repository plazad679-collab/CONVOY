local Config = {
    Locale = "es-ES",
    Framework = {
        Name = "Helix Base",
        Version = "0.1.0"
    },
    Networking = {
        HandshakeEvent = "Helix::Handshake",
        SyncConfigEvent = "Helix::SyncConfig",
        SyncCharacterEvent = "Helix::SyncCharacter",
        SyncInventoryEvent = "Helix::SyncInventory"
    },
    Permissions = {
        Default = "civil",
        Groups = {
            civil = {
                label = "Civil",
                color = Color(35, 196, 131)
            },
            staff = {
                label = "Staff",
                color = Color(124, 92, 255)
            },
            admin = {
                label = "Administrador",
                inherits = {"staff"},
                color = Color(239, 68, 68)
            }
        }
    },
    Characters = {
        MaxPerPlayer = 3,
        DefaultModel = "nanos-world::SK_Mannequin",
        DefaultSpawn = Vector(0, 0, 150)
    },
    Inventory = {
        Slots = 12,
        StartItems = {
            { name = "telefono", label = "Teléfono", quantity = 1 },
            { name = "agua", label = "Botella de agua", quantity = 2 }
        }
    },
    Chat = {
        CommandPrefix = "/",
        Suggestions = {
            {
                command = "/ayuda",
                description = "Muestra la lista de comandos disponibles"
            },
            {
                command = "/pj",
                description = "Gestiona tus personajes"
            }
        }
    }
}

return Config
