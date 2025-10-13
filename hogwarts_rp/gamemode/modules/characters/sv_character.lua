local Characters = Hogwarts.Modules.Characters or {}
local Logger = Hogwarts.Core.Logger
local Net = Hogwarts.Core.Net

Characters.StoragePath = "hogwarts_rp/characters"
Characters.Cache = Characters.Cache or {}
Characters.Sequence = Characters.Sequence or 0

local function ensure_storage()
    if not file.IsDir(Characters.StoragePath, "DATA") then
        file.CreateDir(Characters.StoragePath)
    end
end

local function generate_id()
    Characters.Sequence = Characters.Sequence + 1
    return string.format("CHR-%d-%d", os.time(), Characters.Sequence)
end

function Characters:Initialize()
    ensure_storage()
    Logger:Success("Sistema de personajes inicializado")
end

function Characters:GetPlayerKey(ply)
    return ply:SteamID64() or ply:SteamID()
end

function Characters:LoadPlayer(ply)
    ensure_storage()
    local key = self:GetPlayerKey(ply)
    local file_path = string.format("%s/%s.json", self.StoragePath, key)

    if file.Exists(file_path, "DATA") then
        local content = file.Read(file_path, "DATA")
        local stored = util.JSONToTable(content or "{}") or {}
        self.Cache[key] = stored
    else
        self.Cache[key] = {}
    end

    Logger:Info("Cargados %d personajes para %s", table.Count(self.Cache[key]), ply:Nick())
    return self.Cache[key]
end

function Characters:SavePlayer(ply)
    ensure_storage()
    local key = self:GetPlayerKey(ply)
    local file_path = string.format("%s/%s.json", self.StoragePath, key)
    local data = util.TableToJSON(self.Cache[key] or {}, true)
    file.Write(file_path, data)
end

local function default_stats()
    return {
        courage = 10,
        wisdom = 10,
        ambition = 10,
        loyalty = 10,
        fatigue = 0,
        mana = 100,
        health = 100
    }
end

local function default_inventory()
    return {
        wand = {
            wood = "roble",
            core = "pluma de fénix",
            length = 11.0
        },
        items = {
            { id = "uniforme_hogwarts", quantity = 1 },
            { id = "libro_hechizos", quantity = 1 }
        }
    }
end

function Characters:DefaultSpells(year)
    local spells = {}
    for _, spell in ipairs(Hogwarts.Data.Spells) do
        if spell.year <= (year or Hogwarts.Config.Gameplay.starting_year) then
            table.insert(spells, {
                spell_id = spell.id,
                proficiency = "novice"
            })
        end
    end
    return spells
end

function Characters:Create(ply, payload)
    payload = payload or {}
    if not payload.first_name or not payload.last_name then
        return nil, "missing_name"
    end

    local year = math.Clamp(payload.year or Hogwarts.Config.Gameplay.starting_year, 1, Hogwarts.Config.Gameplay.max_year)
    local character = {
        id = generate_id(),
        player_id = ply:SteamID64(),
        first_name = payload.first_name,
        last_name = payload.last_name,
        house = payload.house or Hogwarts.Modules.Houses:AssignByTraits(payload.traits),
        year = year,
        blood_status = payload.blood_status or "half_blood",
        patronus = payload.patronus,
        traits = payload.traits or {},
        stats = payload.stats or default_stats(),
        inventory = payload.inventory or default_inventory(),
        currency = payload.currency or table.Copy(Hogwarts.Config.Gameplay.default_currency),
        reputation = payload.reputation or {},
        schedule = payload.schedule or Hogwarts.Modules.Schedule:Default(),
    }
    character.spells = payload.spells or self:DefaultSpells(year)

    local key = self:GetPlayerKey(ply)
    self.Cache[key] = self.Cache[key] or {}
    table.insert(self.Cache[key], character)
    self:SavePlayer(ply)

    Logger:Success("Creado personaje %s para %s", character.first_name, ply:Nick())
    Net.Send(ply, Net.Messages.CharacterCreated, character)
    self:Sync(ply)
    Net.Send(ply, Net.Messages.SpellsSync, character.spells or {})
    Hogwarts.Core.EventBus:Emit("character_created", ply, character)
    return character
end

function Characters:Sync(ply)
    local key = self:GetPlayerKey(ply)
    local characters = self.Cache[key] or {}
    Net.Send(ply, Net.Messages.CharactersSync, characters)
end

function Characters:Find(ply, character_id)
    local key = self:GetPlayerKey(ply)
    for _, character in ipairs(self.Cache[key] or {}) do
        if character.id == character_id then
            return character
        end
    end
end

net.Receive(Net.Messages.CharactersRequest, function(_, ply)
    Characters:Sync(ply)
end)

net.Receive(Net.Messages.CharacterCreated, function(_, ply)
    local payload = net.ReadTable() or {}
    local character, err = Characters:Create(ply, payload)
    if not character then
        Net.Send(ply, Net.Messages.CharacterError, { reason = err })
    end
end)

net.Receive(Net.Messages.CharacterSelect, function(_, ply)
    local payload = net.ReadTable() or {}
    local character = Characters:Find(ply, payload.id)
    if character then
        Hogwarts.Core.EventBus:Emit("character_selected", ply, character)
        Net.Send(ply, Net.Messages.SpellsSync, character.spells or {})
    else
        Net.Send(ply, Net.Messages.CharacterError, { reason = "not_found" })
    end
end)

Hogwarts.Modules.Characters = Characters

return Characters
