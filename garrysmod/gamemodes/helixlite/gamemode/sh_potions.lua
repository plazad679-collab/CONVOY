--[[
    Registro compartido de recetas de pociones.
]]

HLX.Potions = HLX.Potions or { Recipes = {} }
local potions = HLX.Potions

function potions.RegisterRecipe(id, data)
    potions.Recipes[id] = data
end

potions.RegisterRecipe("demo", {
    time = 5,
    ingredients = {
        water_bottle = 1,
        herb_common = 2
    },
    result = "demo_potion"
})

return potions
