-- sh_classes.lua
-- Gestión de clases, profesores y reputación.

local MODULE = {}
MODULE.Classes = {
    { name = "Defensa Contra las Artes Oscuras", professor = "Alastor Moody", schedule = "Lunes 18:00", reward = { experience = 25, reputation = 5 } },
    { name = "Pociones Avanzadas", professor = "Severus Snape", schedule = "Martes 20:00", reward = { experience = 30, reputation = 3 } },
    { name = "Encantamientos", professor = "Filius Flitwick", schedule = "Miércoles 19:00", reward = { experience = 20, reputation = 4 } }
}

function MODULE:Init()
    Garkravall.Classes = self
end

function MODULE:AttendClass(ply, classId)
    local classData = self.Classes[classId]
    if not classData then
        ply:ChatPrint("La clase no existe.")
        return
    end

    local data = Garkravall.GetPlayerData(ply)
    data.experience = (data.experience or 0) + classData.reward.experience
    data.reputation = (data.reputation or 0) + classData.reward.reputation

    ply:ChatPrint(string.format("Has asistido a %s y ganado %d XP y %d reputación.", classData.name, classData.reward.experience, classData.reward.reputation))
    Garkravall.BroadcastEvent("ClassAttended", ply, classData)
    if SERVER and Garkravall.SendUIData then
        Garkravall.SendUIData(ply)
    end
end

Garkravall.RegisterModule("classes", MODULE)
