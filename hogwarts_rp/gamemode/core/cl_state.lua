local State = Hogwarts.State
State.characters = State.characters or {}
State.spells = State.spells or {}
State.selected = State.selected or nil

function State:SetCharacters(characters)
    self.characters = characters or {}
    if self.selected and self.selected.id then
        local updated = nil
        for _, character in ipairs(self.characters) do
            if character.id == self.selected.id then
                updated = character
                break
            end
        end
        if updated then
            self.selected = updated
            if self.spells then
                self.selected.spells = self.spells
            end
            if Hogwarts.Modules.Interface and Hogwarts.Modules.Interface.Push then
                Hogwarts.Modules.Interface:Push("characters:selected", self.selected)
            end
        end
    end
    if not self.selected and self.characters[1] then
        self:SelectCharacter(self.characters[1])
    end
    if Hogwarts.Modules.Interface and Hogwarts.Modules.Interface.Push then
        Hogwarts.Modules.Interface:Push("characters:update", self.characters)
    end
end

function State:AddCharacter(character)
    table.insert(self.characters, character)
    self.selected = character
    if character.spells then
        self.spells = character.spells
    end
    if Hogwarts.Modules.Interface and Hogwarts.Modules.Interface.Push then
        Hogwarts.Modules.Interface:Push("characters:created", character)
    end
end

function State:SetSpells(spells)
    self.spells = spells or {}
    if self.selected then
        self.selected.spells = self.spells
    end
    if Hogwarts.Modules.Interface and Hogwarts.Modules.Interface.Push then
        Hogwarts.Modules.Interface:Push("spells:update", self.spells)
    end
end

function State:SelectCharacter(character)
    self.selected = character
    if character and self.spells then
        character.spells = self.spells
    end
    if Hogwarts.Modules.Interface and Hogwarts.Modules.Interface.Push then
        Hogwarts.Modules.Interface:Push("characters:selected", character)
    end
end

Hogwarts.State = State

return State
