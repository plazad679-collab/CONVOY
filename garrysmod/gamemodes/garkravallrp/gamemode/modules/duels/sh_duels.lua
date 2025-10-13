-- sh_duels.lua
-- Sistema de duelos mágicos con proyectiles y registro.

local MODULE = {}
MODULE.ActiveDuels = {}

function MODULE:Init()
    Garkravall.Duels = self
    if SERVER then
        util.AddNetworkString("garkravall_duel_projectile")
    end
end

function MODULE:StartDuel(ply1, ply2)
    if not IsValid(ply1) or not IsValid(ply2) then return end
    self.ActiveDuels[ply1] = ply2
    self.ActiveDuels[ply2] = ply1
    ply1:ChatPrint("Has iniciado un duelo con " .. ply2:Nick())
    ply2:ChatPrint("Has iniciado un duelo con " .. ply1:Nick())
    Garkravall.BroadcastEvent("DuelStarted", ply1, ply2)
end

function MODULE:EndDuel(winner, loser)
    if not IsValid(winner) or not IsValid(loser) then return end
    self.ActiveDuels[winner] = nil
    self.ActiveDuels[loser] = nil
    local data = Garkravall.GetPlayerData(winner)
    data.duelWins = (data.duelWins or 0) + 1
    winner:ChatPrint("Has ganado el duelo contra " .. loser:Nick())
    loser:ChatPrint("Has perdido el duelo contra " .. winner:Nick())
    Garkravall.BroadcastEvent("DuelEnded", winner, loser)
end

if SERVER then
    hook.Add("EntityTakeDamage", "Garkravall_DuelDamage", function(target, dmg)
        local attacker = dmg:GetAttacker()
        if not IsValid(target) or not IsValid(attacker) then return end
        if attacker:IsPlayer() and MODULE.ActiveDuels[attacker] == target then
            if target:Health() - dmg:GetDamage() <= 0 then
                timer.Simple(0, function()
                    MODULE:EndDuel(attacker, target)
                end)
            end
        end
    end)

    hook.Add("PlayerDisconnected", "Garkravall_DuelCleanup", function(ply)
        local opponent = MODULE.ActiveDuels[ply]
        if opponent then
            MODULE.ActiveDuels[opponent] = nil
            MODULE.ActiveDuels[ply] = nil
            opponent:ChatPrint("Tu duelo ha finalizado porque tu rival se ha desconectado.")
        end
    end)

    function MODULE:ShootProjectile(ply, spellId)
        local spell = Garkravall.GetSpell(spellId)
        if not spell then return end

        local ent = ents.Create("prop_combine_ball")
        if not IsValid(ent) then return end
        ent:SetPos(ply:GetShootPos())
        ent:SetOwner(ply)
        ent:Spawn()
        ent:Activate()
        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:SetVelocity(ply:GetAimVector() * 800)
        end

        timer.Simple(5, function()
            if IsValid(ent) then ent:Remove() end
        end)
    end

    net.Receive("garkravall_duel_projectile", function(_, ply)
        local spellId = net.ReadString()
        MODULE:ShootProjectile(ply, spellId)
    end)
else
    function MODULE:RequestProjectile(spellId)
        net.Start("garkravall_duel_projectile")
        net.WriteString(spellId)
        net.SendToServer()
    end
end

Garkravall.RegisterModule("duels", MODULE)
