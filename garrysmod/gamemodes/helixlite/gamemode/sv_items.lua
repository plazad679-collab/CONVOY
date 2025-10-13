--[[
    Registro de ítems.
]]

HLX.Items = HLX.Items or {}
HLX.RegisteredItems = HLX.RegisteredItems or {}

local items = HLX.Items

function items.Register(id, data)
    id = string.lower(id)
    data.id = id
    data.stack = data.stack ~= false
    data.weight = data.weight or 0.1
    HLX.RegisteredItems[id] = data
    HLX.DB.Query(string.format("REPLACE INTO hlx_items (id, name, weight, stack) VALUES ('%s', '%s', %f, %d)", HLX.DB.Escape(id), HLX.DB.Escape(data.name or id), data.weight, data.stack and 1 or 0))
end

function items.Get(id)
    return HLX.RegisteredItems[string.lower(id or "")]
end

function items.InitializeDefaults()
    if items._initialized then return end
    items._initialized = true

    items.Register("water_bottle", {
        name = "Botella de Agua",
        description = "Refresca al mago cansado.",
        stack = true,
        weight = 0.5,
        OnUse = function(ply)
            ply:SetHealth(math.min(ply:Health() + 5, ply:GetMaxHealth()))
        end
    })

    items.Register("basic_wand", {
        name = "Varita Escolar",
        description = "Varita estándar para estudiantes.",
        stack = false,
        weight = 1,
        equip = true,
        OnEquip = function(ply)
            ply:SetNWString("hlx_wand", "basic_wand")
        end
    })

    items.Register("demo_potion", {
        name = "Poción de Demostración",
        description = "Restaura una pequeña cantidad de salud.",
        stack = true,
        weight = 0.3,
        OnUse = function(ply)
            ply:SetHealth(math.min(ply:Health() + 25, ply:GetMaxHealth()))
            HLX.Hooks.Run("HLX:PotionBrewed", ply, "demo_potion")
        end
    })

    items.Register("herb_common", {
        name = "Hierba Común",
        description = "Ingrediente básico para pociones.",
        stack = true,
        weight = 0.1
    })
end

return items
