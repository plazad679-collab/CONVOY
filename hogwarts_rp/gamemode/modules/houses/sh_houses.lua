local Houses = {}
Houses.Data = Hogwarts.Data.Houses

local traits_to_house = {
    coraje = "Gryffindor",
    caballerosidad = "Gryffindor",
    determinación = "Gryffindor",
    lealtad = "Hufflepuff",
    paciencia = "Hufflepuff",
    ["trabajo duro"] = "Hufflepuff",
    inteligencia = "Ravenclaw",
    creatividad = "Ravenclaw",
    sabiduría = "Ravenclaw",
    ambición = "Slytherin",
    astucia = "Slytherin"
}

function Houses:AssignByTraits(traits)
    traits = traits or {}
    local tally = {}

    for _, trait in ipairs(traits) do
        local house = traits_to_house[string.lower(trait)]
        if house then
            tally[house] = (tally[house] or 0) + 1
        end
    end

    local selected, score = nil, 0
    for house, count in pairs(tally) do
        if count > score then
            selected = house
            score = count
        end
    end

    if not selected then
        local houses = table.GetKeys(self.Data)
        selected = houses[math.random(#houses)]
    end

    return selected
end

Hogwarts.Modules.Houses = Houses

return Houses
