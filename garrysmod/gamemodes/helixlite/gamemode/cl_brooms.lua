--[[
    Control básico de escobas.
]]

HLX.ClientBrooms = HLX.ClientBrooms or {}
local cb = HLX.ClientBrooms

function cb.Toggle(state)
    net.Start("hlx_brooms")
    net.WriteBool(state)
    net.SendToServer()
end

concommand.Add("hlx_broom", function(_, _, args)
    local state = tobool(args[1])
    cb.Toggle(state)
end)
