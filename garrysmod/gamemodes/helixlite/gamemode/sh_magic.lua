--[[
    Sistema principal de magia compartido.
]]

HLX = HLX or {}
HLX.Magic = HLX.Magic or { Spells = {}, Wands = {} }

local magic = HLX.Magic

function magic.RegisterSpell(id, data)
    id = string.lower(id)
    data.id = id
    magic.Spells[id] = data
end

function magic.GetSpell(id)
    return magic.Spells[string.lower(id or "")]
end

function magic.RegisterWand(id, data)
    id = string.lower(id)
    data.id = id
    magic.Wands[id] = data
end

function magic.GetWand(id)
    return magic.Wands[string.lower(id or "")]
end

function magic.InitializeDefaults()
    if magic._initialized then return end
    magic._initialized = true

    magic.RegisterWand("basic_wand", {
        name = "Varita de Fresno",
        wood = "Fresno",
        core = "Pluma de fénix",
        length = 12,
        flexibility = "Media",
        affinities = { charm = 0.1 },
        rarity = "common"
    })

    magic.RegisterSpell("water_splash", {
        name = "Aqua Mundi",
        incantation = "Aqua Mundi",
        cooldown = 5,
        mana_cost = 10,
        school = "utility",
        min_year = 1,
        server = {
            CanCast = function(ply)
                return true
            end,
            OnCast = function(ply, trace)
                if not trace then return false end
                util.Decal("Splash.Large", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
                return true
            end
        },
        client = {
            OnFX = function(ply, trace)
                if not trace then return end
                local effect = EffectData()
                effect:SetOrigin(trace.HitPos)
                util.Effect("WaterSplash", effect)
            end
        }
    })
end

return magic
