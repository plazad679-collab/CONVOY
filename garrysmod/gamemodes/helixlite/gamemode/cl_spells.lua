--[[
    Efectos de hechizos cliente.
]]

HLX.ClientSpells = HLX.ClientSpells or {}
local cspells = HLX.ClientSpells

function cspells.Initialize()
    net.Receive("hlx_spells", function()
        local spellID = net.ReadString()
        local pos = net.ReadVector()
        local spell = HLX.Magic.GetSpell(spellID)
        if spell and spell.client and spell.client.OnFX then
            HLX.Util.SafeCall(spell.client.OnFX, LocalPlayer(), { HitPos = pos })
        else
            local effect = EffectData()
            effect:SetOrigin(pos)
            util.Effect("cball_explode", effect)
        end
    end)
end

function cspells.Cast(spellID)
    if not spellID then return end
    net.Start("hlx_spells")
    net.WriteString(spellID)
    net.SendToServer()
end

concommand.Add("hlx_cast", function(_, _, args)
    cspells.Cast(args[1])
end)

cspells.Initialize()
