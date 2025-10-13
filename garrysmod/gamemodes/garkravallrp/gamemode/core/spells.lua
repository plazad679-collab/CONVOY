-- core/spells.lua
-- Sistema base para registrar y manejar hechizos.

Garkravall = Garkravall or {}
Garkravall.Spells = Garkravall.Spells or {}

function Garkravall.RegisterSpell(identifier, data)
    data.identifier = identifier
    data.name = data.name or "Hechizo sin nombre"
    data.description = data.description or ""
    data.cooldown = data.cooldown or 3
    data.sound = data.sound or ""
    data.particle = data.particle or ""

    Garkravall.Spells[identifier] = data
    Garkravall.Log("Hechizo registrado: " .. data.name)
end

function Garkravall.GetSpell(identifier)
    return Garkravall.Spells[identifier]
end

function Garkravall.CastSpell(ply, identifier)
    local spell = Garkravall.GetSpell(identifier)
    if not spell then return end

    if SERVER then
        if spell.sound and spell.sound ~= "" then
            ply:EmitSound(spell.sound)
        end

        local cooldownKey = "spellCooldown_" .. identifier
        local data = Garkravall.GetPlayerData(ply)
        data.cooldowns = data.cooldowns or {}
        if data.cooldowns[cooldownKey] and data.cooldowns[cooldownKey] > CurTime() then
            ply:ChatPrint("Necesitas esperar antes de lanzar " .. spell.name .. ".")
            return
        end

        data.cooldowns[cooldownKey] = CurTime() + spell.cooldown

        if spell.OnCast then
            spell.OnCast(ply)
        end

        Garkravall.BroadcastEvent("SpellCast", ply, spell)
    end
end

if SERVER then
    util.AddNetworkString("garkravall_cast_spell")

    net.Receive("garkravall_cast_spell", function(_, ply)
        local spellId = net.ReadString()
        Garkravall.CastSpell(ply, spellId)
    end)
else
    function Garkravall.RequestSpellCast(identifier)
        net.Start("garkravall_cast_spell")
        net.WriteString(identifier)
        net.SendToServer()
    end
end
