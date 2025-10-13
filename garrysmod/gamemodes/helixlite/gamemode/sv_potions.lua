--[[
    Sistema de pociones.
]]

HLX.Potions = HLX.Potions or { Recipes = {} }
local potions = HLX.Potions

function potions.StartBrew(ply, recipeID)
    local recipe = potions.Recipes[recipeID]
    if not recipe then return false end
    for itemID, qty in pairs(recipe.ingredients) do
        if not HLX.Inventory.Remove(ply, itemID, qty, true) then
            return false
        end
    end

    timer.Simple(recipe.time, function()
        if not IsValid(ply) then return end
        HLX.Inventory.Add(ply, recipe.result, 1)
        HLX.Hooks.Run("HLX:PotionBrewed", ply, recipe.result)
    end)
    return true
end

net.Receive("hlx_potions", function(len, ply)
    local recipeID = net.ReadString()
    potions.StartBrew(ply, recipeID)
end)

return potions
