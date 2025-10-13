--[[
    Manejo de hechizos servidor.
]]

HLX.Spells = HLX.Spells or {}
local spells = HLX.Spells

local castRateLimit = {}

local function canCast(ply, spellID)
    local spell = HLX.Magic.GetSpell(spellID)
    if not spell then return false, "Hechizo desconocido" end

    local now = CurTime()
    castRateLimit[ply] = castRateLimit[ply] or {}
    if castRateLimit[ply][spellID] and castRateLimit[ply][spellID] > now then
        return false, "Cooldown"
    end
    if ply.HLXNextCast and ply.HLXNextCast > now then
        return false, "Cooldown global"
    end

    local mana = ply:GetNWInt("hlx_mana", HLX.Config.ManaBase)
    if mana < spell.mana_cost then
        return false, "Sin maná"
    end

    if spell.server and spell.server.CanCast then
        local ok, err = spell.server.CanCast(ply, {})
        if ok == false then
            return false, err or "Condiciones no cumplidas"
        end
    end

    if HLX.Rules and HLX.Rules.CanCastSpell then
        local allowed, reason = HLX.Rules.CanCastSpell(ply, spellID)
        if allowed == false then
            return false, reason
        end
    end

    return true
end

local function takeMana(ply, amount, school)
    local affinity = HLX.Wands.GetAffinity(ply, school)
    amount = math.max(0, amount - (amount * affinity))
    local mana = ply:GetNWInt("hlx_mana", HLX.Config.ManaBase)
    mana = math.max(0, mana - amount)
    ply:SetNWInt("hlx_mana", mana)
end

function spells.PerformCast(ply, spellID)
    local ok, err = canCast(ply, spellID)
    if not ok then
        net.Start("hlx_notifications")
        net.WriteString(err or "Error")
        net.Send(ply)
        return
    end
    local spell = HLX.Magic.GetSpell(spellID)

    local trace = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * 2048,
        filter = ply
    })

    if spell.server and spell.server.OnCast then
        local success = spell.server.OnCast(ply, trace)
        if success == false then
            net.Start("hlx_notifications")
            net.WriteString(HLX.Translate("notification_spell_failed"))
            net.Send(ply)
            return
        end
    end

    takeMana(ply, spell.mana_cost, spell.school)
    castRateLimit[ply][spellID] = CurTime() + (spell.cooldown or 1)
    ply.HLXNextCast = CurTime() + HLX.Config.GlobalSpellCooldown

    net.Start("hlx_spells")
    net.WriteString(spellID)
    net.WriteVector(trace.HitPos)
    net.Broadcast()

    HLX.Hooks.Run("HLX:SpellCast", ply, spellID, trace)
end

net.Receive("hlx_spells", function(len, ply)
    local spellID = string.lower(net.ReadString() or "")
    spells.PerformCast(ply, spellID)
end)

function spells.Command(ply, args)
    local spellID = string.lower(args[2] or "")
    spells.PerformCast(ply, spellID)
end

return spells
