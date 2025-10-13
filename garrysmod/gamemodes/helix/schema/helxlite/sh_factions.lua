local FACTIONS = {}

FACTIONS.gryffindor = {
    name = "Gryffindor",
    description = "Los valientes y audaces estudiantes del león rojo y dorado, conocidos por su determinación y espíritu caballeroso.",
    color = Color(184, 29, 19),
    models = {
        "models/player/Group01/male_02.mdl",
        "models/player/Group01/female_02.mdl"
    },
    isDefault = false,
    index = 1
}

FACTIONS.slytherin = {
    name = "Slytherin",
    description = "Magos y brujas ambiciosos que valoran la astucia, el liderazgo y la determinación bajo los estandartes verde y plata.",
    color = Color(23, 94, 52),
    models = {
        "models/player/Group03/male_04.mdl",
        "models/player/Group03/female_04.mdl"
    },
    isDefault = false,
    index = 2
}

FACTIONS.ravenclaw = {
    name = "Ravenclaw",
    description = "Eruditos creativos que celebran la sabiduría, el ingenio y el aprendizaje constante en los tonos azul y bronce.",
    color = Color(25, 49, 112),
    models = {
        "models/player/Group01/male_08.mdl",
        "models/player/Group01/female_07.mdl"
    },
    isDefault = false,
    index = 3
}

FACTIONS.hufflepuff = {
    name = "Hufflepuff",
    description = "Miembros leales y pacientes que valoran la justicia, la dedicación y el trabajo duro bajo el amarillo y negro.",
    color = Color(227, 171, 39),
    models = {
        "models/player/Group02/male_05.mdl",
        "models/player/Group02/female_05.mdl"
    },
    isDefault = false,
    index = 4
}

FACTIONS.professors = {
    name = "Profesores",
    description = "Docentes de Hogwarts responsables de guiar, proteger y evaluar a los estudiantes en su vida académica y mágica.",
    color = Color(120, 72, 166),
    models = {
        "models/player/kleiner.mdl",
        "models/player/magnusson.mdl"
    },
    isDefault = false,
    index = 5
}

FACTIONS.deatheaters = {
    name = "Mortífagos",
    description = "Seguidores leales del Señor Tenebroso, dedicados a la magia oscura y a expandir su influencia por el mundo mágico.",
    color = Color(34, 34, 34),
    models = {
        "models/player/Group03/male_07.mdl",
        "models/player/Group03/female_02.mdl"
    },
    isDefault = false,
    index = 6
}

FACTIONS.ministry = {
    name = "Ministerio de Magia",
    description = "Funcionarios burocráticos y agentes del gobierno mágico encargados de mantener el orden y las leyes del mundo de los magos.",
    color = Color(18, 82, 117),
    models = {
        "models/player/Group03/male_02.mdl",
        "models/player/Group03/female_06.mdl"
    },
    isDefault = false,
    index = 7
}

FACTIONS.auror = {
    name = "Auror",
    description = "Expertos combatientes contra las artes oscuras que trabajan para proteger al mundo mágico de amenazas peligrosas.",
    color = Color(70, 130, 180),
    models = {
        "models/player/swat.mdl",
        "models/player/police.mdl"
    },
    isDefault = false,
    index = 8
}

FACTIONS.students = {
    name = "Estudiantes",
    description = "Aprendices de Hogwarts sin casa asignada o visitantes que se integran a la vida escolar de forma neutral.",
    color = Color(204, 204, 204),
    models = {
        "models/player/Group01/male_06.mdl",
        "models/player/Group01/female_06.mdl"
    },
    isDefault = true,
    index = 9
}

local FACTION = FACTIONS.gryffindor
FACTION_GRYFFINDOR = FACTION.index
ix.faction.Register(FACTION, "gryffindor")

FACTION = FACTIONS.slytherin
FACTION_SLYTHERIN = FACTION.index
ix.faction.Register(FACTION, "slytherin")

FACTION = FACTIONS.ravenclaw
FACTION_RAVENCLAW = FACTION.index
ix.faction.Register(FACTION, "ravenclaw")

FACTION = FACTIONS.hufflepuff
FACTION_HUFFLEPUFF = FACTION.index
ix.faction.Register(FACTION, "hufflepuff")

FACTION = FACTIONS.professors
FACTION_PROFESORES = FACTION.index
ix.faction.Register(FACTION, "profesores")

FACTION = FACTIONS.deatheaters
FACTION_MORTIFAGOS = FACTION.index
ix.faction.Register(FACTION, "mortifagos")

FACTION = FACTIONS.ministry
FACTION_MINISTERIO = FACTION.index
ix.faction.Register(FACTION, "ministerio")

FACTION = FACTIONS.auror
FACTION_AUROR = FACTION.index
ix.faction.Register(FACTION, "auror")

FACTION = FACTIONS.students
FACTION_ESTUDIANTES = FACTION.index
ix.faction.Register(FACTION, "estudiantes")
