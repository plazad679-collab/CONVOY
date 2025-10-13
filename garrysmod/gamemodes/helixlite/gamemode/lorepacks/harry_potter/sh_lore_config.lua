return {
    name = "Harry Potter",
    description = "Preset mágico inspirado en Hogwarts",
    factions = {
        gryffindor = { name = "Gryffindor", color = Color(184, 46, 36), permissions = {"hlx.basic", "hlx.learn"} },
        slytherin = { name = "Slytherin", color = Color(26, 71, 42), permissions = {"hlx.basic", "hlx.learn"} },
        ravenclaw = { name = "Ravenclaw", color = Color(33, 90, 150), permissions = {"hlx.basic", "hlx.learn"} },
        hufflepuff = { name = "Hufflepuff", color = Color(227, 182, 52), permissions = {"hlx.basic", "hlx.learn"} },
        auror = { name = "Auror Office", color = Color(120, 120, 200), permissions = {"hlx.defense"} }
    },
    roles = {
        professor = { weight = 60, inherits = "auror", permissions = {"hlx.professor", "hlx.manage"} },
        prefect = { weight = 70, inherits = "professor", permissions = {"hlx.prefect"} }
    },
    items = {
        wand_legendary = {
            name = "Varita Legendaria",
            description = "Una varita poderosa con afinidad defensiva.",
            stack = false,
            weight = 1,
            OnEquip = function(ply)
                HLX.Wands.Assign(ply, "wand_legendary")
            end
        },
        potion_wiggenweld = {
            name = "Poción Wiggenweld",
            description = "Cura moderada.",
            stack = true,
            weight = 0.3,
            OnUse = function(ply)
                ply:SetHealth(math.min(ply:Health() + 35, ply:GetMaxHealth()))
            end
        },
        chocolate_frog = {
            name = "Chocolate Frog",
            description = "Dulce mágico que cura ligeramente y otorga una carta.",
            stack = true,
            weight = 0.2,
            OnUse = function(ply)
                ply:SetHealth(math.min(ply:Health() + 10, ply:GetMaxHealth()))
                net.Start("hlx_notifications")
                net.WriteString("Has conseguido una carta coleccionable!")
                net.Send(ply)
            end
        }
    },
    spells = {
        expelliarmus = {
            name = "Expelliarmus",
            incantation = "Expelliarmus",
            cooldown = 8,
            mana_cost = 20,
            school = "defense",
            min_year = 3,
            server = {
                OnCast = function(ply, trace)
                    if not IsValid(trace.Entity) or not trace.Entity:IsPlayer() then return false end
                    local weapon = trace.Entity:GetActiveWeapon()
                    if IsValid(weapon) then
                        trace.Entity:DropWeapon(weapon)
                    end
                    trace.Entity:SetNWFloat("hlx_disarmed", CurTime() + 4)
                    return true
                end
            },
            client = {
                OnFX = function(ply, ctx)
                    local effect = EffectData()
                    effect:SetOrigin(ctx.HitPos)
                    util.Effect("StunstickImpact", effect)
                end
            }
        },
        lumos = {
            name = "Lumos",
            incantation = "Lumos",
            cooldown = 2,
            mana_cost = 5,
            school = "utility",
            min_year = 1,
            server = {
                OnCast = function(ply)
                    ply:SetNWBool("hlx_lumos", true)
                    return true
                end
            },
            client = {
                OnFX = function(ply)
                    ply.HLX_LumosLight = DynamicLight(ply:EntIndex())
                    if ply.HLX_LumosLight then
                        ply.HLX_LumosLight.pos = ply:GetPos() + Vector(0, 0, 60)
                        ply.HLX_LumosLight.r = 200
                        ply.HLX_LumosLight.g = 200
                        ply.HLX_LumosLight.b = 255
                        ply.HLX_LumosLight.Decay = 1000
                        ply.HLX_LumosLight.Size = 128
                        ply.HLX_LumosLight.DieTime = CurTime() + 30
                    end
                end
            }
        },
        nox = {
            name = "Nox",
            incantation = "Nox",
            cooldown = 2,
            mana_cost = 1,
            school = "utility",
            min_year = 1,
            server = {
                OnCast = function(ply)
                    ply:SetNWBool("hlx_lumos", false)
                    return true
                end
            },
            client = {
                OnFX = function(ply)
                    ply.HLX_LumosLight = nil
                end
            }
        },
        protego = {
            name = "Protego",
            incantation = "Protego",
            cooldown = 12,
            mana_cost = 25,
            school = "defense",
            min_year = 3,
            server = {
                OnCast = function(ply)
                    ply:SetNWFloat("hlx_protego", CurTime() + 6)
                    return true
                end
            },
            client = {
                OnFX = function(ply)
                    surface.PlaySound("ambient/energy/force_field_loop1.wav")
                end
            }
        },
        stupefy = {
            name = "Stupefy",
            incantation = "Stupefy",
            cooldown = 15,
            mana_cost = 30,
            school = "defense",
            min_year = 4,
            server = {
                OnCast = function(ply, trace)
                    if not IsValid(trace.Entity) or not trace.Entity:IsPlayer() then return false end
                    trace.Entity:Freeze(true)
                    timer.Simple(3, function()
                        if IsValid(trace.Entity) then
                            trace.Entity:Freeze(false)
                        end
                    end)
                    return true
                end
            },
            client = {
                OnFX = function(ply, ctx)
                    util.ScreenShake(ctx.HitPos, 5, 5, 1, 128)
                end
            }
        },
        alohomora = {
            name = "Alohomora",
            incantation = "Alohomora",
            cooldown = 10,
            mana_cost = 15,
            school = "utility",
            min_year = 2,
            server = {
                OnCast = function(ply, trace)
                    if not IsValid(trace.Entity) then return false end
                    if trace.Entity.Fire then
                        trace.Entity:Fire("Unlock")
                        trace.Entity:Fire("Open")
                    end
                    return true
                end
            },
            client = {
                OnFX = function(ply)
                    surface.PlaySound("buttons/lever7.wav")
                end
            }
        }
    },
    wands = {
        wand_legendary = {
            name = "Varita Legendaria",
            wood = "Sauce",
            core = "Pluma de fénix",
            length = 14,
            flexibility = "Rígida",
            affinities = { defense = 0.2, charm = 0.1 },
            rarity = "legendary"
        }
    }
}
