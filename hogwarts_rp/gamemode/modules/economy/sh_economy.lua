local Economy = {}

function Economy:Default()
    return table.Copy(Hogwarts.Config.Gameplay.default_currency)
end

function Economy:Transfer(character, galeons, sickles, knuts)
    character.currency = character.currency or self:Default()
    character.currency.galeons = math.max(0, (character.currency.galeons or 0) + (galeons or 0))
    character.currency.sickles = math.max(0, (character.currency.sickles or 0) + (sickles or 0))
    character.currency.knuts = math.max(0, (character.currency.knuts or 0) + (knuts or 0))
end

Hogwarts.Modules.Economy = Economy

return Economy
