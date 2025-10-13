--[[
    Sistema de notificaciones.
]]

HLX.Notifications = HLX.Notifications or {}
local notifications = HLX.Notifications

notifications.Queue = notifications.Queue or {}

function notifications.Initialize()
    net.Receive("hlx_notifications", function()
        local message = net.ReadString()
        table.insert(notifications.Queue, { text = message, time = CurTime() + 4 })
    end)

    hook.Add("HUDPaint", "HLX.DrawNotifications", function()
        local y = 80
        for k, data in ipairs(notifications.Queue) do
            if data.time < CurTime() then
                table.remove(notifications.Queue, k)
            else
                draw.SimpleTextOutlined(data.text, "HLX_Text", ScrW() - 20, y, Color(200, 220, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
                y = y + 20
            end
        end
    end)
end

return notifications
