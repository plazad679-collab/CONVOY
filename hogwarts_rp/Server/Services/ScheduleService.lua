local Logger = Package.Require("Shared/Modules/Logger.lua")
local MySQL = Package.Require("Server/Database/MySQL.lua")
local Classes = Package.Require("Shared/Data/Classes.lua")
local TableUtils = Package.Require("Shared/Modules/TableUtils.lua")

local ScheduleService = {}
ScheduleService.classes_index = TableUtils.index_by(Classes, "id")

function ScheduleService:get_classes()
    return Classes
end

function ScheduleService:assign_class(character_id, class_id, day, start_time, end_time)
    local class = self.classes_index[class_id]
    if not class then
        return false, "class_not_found"
    end

    MySQL:execute([[INSERT INTO hogwarts_classes (class_id, day_of_week, starts_at, ends_at, location, professor)
        VALUES (?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE location = VALUES(location), professor = VALUES(professor)]], {
        class_id,
        day,
        start_time,
        end_time,
        class.location,
        class.professor
    })

    MySQL:execute([[INSERT INTO hogwarts_attendance (class_instance_id, character_id, attendance_date, status)
        VALUES ((SELECT id FROM hogwarts_classes WHERE class_id = ? AND day_of_week = ? AND starts_at = ?), ?, CURDATE(), 'present')
        ON DUPLICATE KEY UPDATE status = VALUES(status)]], {
        class_id,
        day,
        start_time,
        character_id
    })

    Logger:info("Asignado personaje %d a clase %s", character_id, class_id)
    return true
end

return ScheduleService
