local Schedule = {}

function Schedule:Default()
    return {
        classes = {},
        detentions = {},
        quidditch = {}
    }
end

function Schedule:Assign(character, class_id, day, time)
    character.schedule = character.schedule or self:Default()
    character.schedule.classes = character.schedule.classes or {}
    table.insert(character.schedule.classes, {
        class_id = class_id,
        day_of_week = day,
        starts_at = time
    })
end

Hogwarts.Modules.Schedule = Schedule

return Schedule
