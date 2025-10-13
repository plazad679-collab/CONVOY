local Logger = {}
Logger.levels = {
    info = Color(180, 200, 255),
    warn = Color(255, 200, 0),
    error = Color(255, 80, 80),
    success = Color(120, 255, 120)
}

local function print_message(level, message)
    local color = Logger.levels[level] or color_white
    MsgC(color, string.format("[Hogwarts] [%s] %s\n", string.upper(level), message))
end

function Logger:Info(message, ...)
    print_message("info", string.format(message, ...))
end

function Logger:Warn(message, ...)
    print_message("warn", string.format(message, ...))
end

function Logger:Error(message, ...)
    print_message("error", string.format(message, ...))
end

function Logger:Success(message, ...)
    print_message("success", string.format(message, ...))
end

Hogwarts.Core.Logger = Logger

return Logger
