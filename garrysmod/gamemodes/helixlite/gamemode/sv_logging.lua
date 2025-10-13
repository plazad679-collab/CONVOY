--[[
    Sistema de logging para HelixLite.
]]

HLX.Logging = HLX.Logging or {}

local logPath = "helixlite/logs/"

local function writeFile(prefix, msg)
    if not file.IsDir("helixlite", "DATA") then
        file.CreateDir("helixlite")
    end
    if not file.IsDir("helixlite/logs", "DATA") then
        file.CreateDir("helixlite/logs")
    end
    local fileName = os.date("%Y-%m-%d") .. "_" .. prefix .. ".txt"
    file.Append(logPath .. fileName, os.date("[%H:%M:%S]") .. " " .. msg .. "\n")
end

function HLX.Logging.Info(msg)
    MsgC(Color(100, 200, 255), "[HLX] ", color_white, msg .. "\n")
    if GetConVar("hlx_enable_persistence"):GetBool() then
        writeFile("info", msg)
    end
end

function HLX.Logging.Warn(msg)
    MsgC(Color(255, 200, 50), "[HLX] ", color_white, msg .. "\n")
    writeFile("warn", msg)
end

function HLX.Logging.Error(msg)
    MsgC(Color(255, 50, 50), "[HLX] ", color_white, msg .. "\n")
    writeFile("error", msg)
end

return HLX.Logging
