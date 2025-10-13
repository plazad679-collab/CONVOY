local Character = {}
Character.__index = Character

function Character:New(data)
    local instance = setmetatable({}, Character)
    instance.id = data.id
    instance.player_id = data.player_id
    instance.first_name = data.first_name
    instance.last_name = data.last_name
    instance.house = data.house
    instance.year = data.year
    instance.blood_status = data.blood_status
    instance.patronus = data.patronus
    instance.traits = data.traits or {}
    instance.stats = data.stats or {}
    instance.inventory = data.inventory or {}
    instance.currency = data.currency or Hogwarts.Config.Gameplay.default_currency
    instance.reputation = data.reputation or {}
    instance.schedule = data.schedule or {}
    instance.spells = data.spells or {}
    return instance
end

function Character:GetFullName()
    return string.Trim(string.format("%s %s", self.first_name or "", self.last_name or ""))
end

function Character:Serialize()
    return {
        id = self.id,
        player_id = self.player_id,
        first_name = self.first_name,
        last_name = self.last_name,
        house = self.house,
        year = self.year,
        blood_status = self.blood_status,
        patronus = self.patronus,
        traits = self.traits,
        stats = self.stats,
        inventory = self.inventory,
        currency = self.currency,
        reputation = self.reputation,
        schedule = self.schedule,
        spells = self.spells
    }
end

Hogwarts.Modules.Characters = Hogwarts.Modules.Characters or {}
Hogwarts.Modules.Characters.Meta = Character

return Character
