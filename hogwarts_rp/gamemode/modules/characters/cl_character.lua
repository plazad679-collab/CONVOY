local Net = Hogwarts.Core.Net
local State = Hogwarts.State

net.Receive(Net.Messages.CharactersSync, function()
    local characters = net.ReadTable() or {}
    State:SetCharacters(characters)
end)

net.Receive(Net.Messages.CharacterCreated, function()
    local character = net.ReadTable() or {}
    State:AddCharacter(character)
end)

net.Receive(Net.Messages.CharacterError, function()
    local payload = net.ReadTable() or { reason = "unknown" }
    local ui = Hogwarts.Modules.Interface
    if ui and ui.Push then
        ui:Push("characters:create_failed", payload)
    end
end)

hook.Add("Hogwarts.CharacterSelected", "Hogwarts.UpdateSpells", function(character)
    State:SelectCharacter(character)
end)

return true
