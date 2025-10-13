--[[
    Reglas de zonas y restricciones.
]]

HLX.Rules = HLX.Rules or {}
local rules = HLX.Rules

rules.RestrictedSpells = {
    low_year = {
        "expelliarmus",
        "stupefy"
    }
}

function rules.CanCastSpell(ply, spellID)
    local year = ply:GetNWInt("hlx_year", 1)
    if year < 3 then
        for _, spell in ipairs(rules.RestrictedSpells.low_year) do
            if spell == spellID then
                if HLX.Permissions.HasPerm(ply, "hlx.prefect") or HLX.Permissions.HasPerm(ply, "hlx.professor") then
                    return true
                end
                return false, "Necesitas más experiencia"
            end
        end
    end

    if HLX.Zones.IsPositionSafe(ply:GetPos()) then
        local zone = HLX.Zones.Get("library")
        if zone and zone.blocked_spells then
            for _, block in ipairs(zone.blocked_spells) do
                if block == spellID then
                    return false, "Hechizo bloqueado en la zona"
                end
            end
        end
    end

    return true
end

hook.Add("HLX:SpellCast", "HLX.RuleCheck", function(ply, spellID)
    local ok, reason = rules.CanCastSpell(ply, spellID)
    if ok == false then
        net.Start("hlx_notifications")
        net.WriteString(reason or "Hechizo bloqueado")
        net.Send(ply)
        return false
    end
end)

return rules
