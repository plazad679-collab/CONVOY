-- shared.lua
-- Define configuraciones compartidas del gamemode.

DeriveGamemode("sandbox")

GM.Name = "GarkravallRP"
GM.Author = "Equipo Garkravall"
GM.Email = "soporte@garkravallrp.com"
GM.Website = "https://garkravallrp.example.com"

include("core/loader.lua")

-- Registro de hechizos base.
Garkravall.RegisterSpell("expelliarmus", {
    name = "Expelliarmus",
    description = "Desarma al oponente con un destello rojo.",
    cooldown = 5,
    sound = "garkravall/spells/expelliarmus.wav",
    OnCast = function(ply)
        ply:ChatPrint("Has lanzado Expelliarmus!")
    end
})

Garkravall.RegisterSpell("stupefy", {
    name = "Stupefy",
    description = "Aturde al objetivo y causa daño leve.",
    cooldown = 7,
    sound = "garkravall/spells/stupefy.wav",
    OnCast = function(ply)
        ply:ChatPrint("Has lanzado Stupefy!")
    end
})

Garkravall.RegisterSpell("protego", {
    name = "Protego",
    description = "Genera un escudo protector momentáneo.",
    cooldown = 10,
    sound = "garkravall/spells/protego.wav",
    OnCast = function(ply)
        ply:ChatPrint("Has invocado Protego!")
    end
})
