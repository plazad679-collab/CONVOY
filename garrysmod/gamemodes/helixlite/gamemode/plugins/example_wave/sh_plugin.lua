local salvioSpell = {
    name = "Salvio Hexia",
    incantation = "Salvio",
    cooldown = 10,
    mana_cost = 25,
    school = "defense",
    min_rank = "prefect",
    server = {
        CanCast = function(ply)
            return true
        end,
        OnCast = function(ply, trace)
            ply:SetNWFloat("hlx_salvio", CurTime() + 6)
            return true
        end
    },
    client = {
        OnFX = function(ply, ctx)
            local emitter = ParticleEmitter(ctx.HitPos or ply:GetPos())
            if not emitter then return end
            for i = 1, 16 do
                local particle = emitter:Add("effects/yellowflare", ply:GetPos())
                if particle then
                    particle:SetVelocity(VectorRand() * 60)
                    particle:SetDieTime(0.6)
                    particle:SetStartAlpha(200)
                    particle:SetEndAlpha(0)
                    particle:SetStartSize(10)
                    particle:SetEndSize(0)
                end
            end
            emitter:Finish()
        end
    }
}

local PLUGIN = {
    name = "Example Wave",
    author = "Convoy",
    version = "1.0",
    description = "Plugin de ejemplo con comando /wave y hechizo salvio",
    load_order = 1,
    server = {},
    client = {}
}

PLUGIN.server.init = function()
    HLX.Commands.Register("wave", {
        run = function(ply)
            ply:DoAnimationEvent(ACT_GMOD_GESTURE_WAVE)
            HLX.Logging.Info(ply:Nick() .. " saluda a todos")
        end
    })

    HLX.Magic.RegisterSpell("salvio", salvioSpell)
end

PLUGIN.client.init = function()
    HLX.Magic.RegisterSpell("salvio", salvioSpell)
    hook.Add("PostPlayerDraw", "HLX.SalvioShield", function(ply)
        if ply:GetNWFloat("hlx_salvio", 0) > CurTime() then
            render.SetColorMaterial()
            render.DrawSphere(ply:GetPos() + Vector(0, 0, 40), 40, 16, 16, Color(120, 120, 255, 80))
        end
    end)
end

return PLUGIN
