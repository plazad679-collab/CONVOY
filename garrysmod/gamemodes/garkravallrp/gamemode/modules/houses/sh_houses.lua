-- sh_houses.lua
-- Define las casas mágicas disponibles y sus características.

local MODULE = {}
MODULE.Houses = {
    Gryffindor = {
        color = Color(174, 0, 1),
        emblem = "materials/garkravall/houses/gryffindor.png",
        traits = {"Valor", "Caballerosidad"}
    },
    Slytherin = {
        color = Color(25, 89, 54),
        emblem = "materials/garkravall/houses/slytherin.png",
        traits = {"Ambición", "Astucia"}
    },
    Ravenclaw = {
        color = Color(25, 55, 109),
        emblem = "materials/garkravall/houses/ravenclaw.png",
        traits = {"Inteligencia", "Creatividad"}
    },
    Hufflepuff = {
        color = Color(239, 182, 56),
        emblem = "materials/garkravall/houses/hufflepuff.png",
        traits = {"Lealtad", "Trabajo"}
    }
}

function MODULE:Init()
    Garkravall.Houses = self.Houses
end

function MODULE:GetHouse(name)
    return self.Houses[name]
end

function MODULE:AssignHouse(ply, houseName)
    local house = self.Houses[houseName]
    if not house then
        ply:ChatPrint("La casa seleccionada no existe.")
        return
    end

    ply:GarkravallSetHouse(houseName)
    if SERVER then
        ply:SetPlayerColor(Vector(house.color.r / 255, house.color.g / 255, house.color.b / 255))
    end
end

function MODULE:GetRandomHouse()
    local keys = table.GetKeys(self.Houses)
    return keys[math.random(#keys)]
end

Garkravall.RegisterModule("houses", MODULE)
