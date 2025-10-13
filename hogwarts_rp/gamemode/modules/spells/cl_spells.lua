local Net = Hogwarts.Core.Net
local State = Hogwarts.State

net.Receive(Net.Messages.SpellsSync, function()
    local spells = net.ReadTable() or {}
    State:SetSpells(spells)
end)

net.Receive(Net.Messages.SpellCast, function()
    local payload = net.ReadTable() or {}
    local ui = Hogwarts.Modules.Interface
    if ui and ui.Push then
        ui:Push("spells:cast_success", payload)
    end
end)

net.Receive(Net.Messages.SpellFailed, function()
    local payload = net.ReadTable() or { reason = "unknown" }
    local ui = Hogwarts.Modules.Interface
    if ui and ui.Push then
        ui:Push("spells:cast_failed", payload)
    end
end)

return true
