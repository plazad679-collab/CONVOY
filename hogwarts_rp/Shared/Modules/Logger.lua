local Logger = {}
Logger.prefix = "[HogwartsRP]"
Logger.levels = {
    trace = 0,
    debug = 1,
    info = 2,
    warn = 3,
    error = 4,
    fatal = 5
}
Logger.minimum_level = Logger.levels.debug

local function can_log(level)
    return Logger.levels[level] and Logger.levels[level] >= Logger.minimum_level
end

local function format_message(level, message, ...)
    local ok, formatted = pcall(string.format, message, ...)
    if not ok then
        formatted = message
    end
    return string.format("%s[%s] %s", Logger.prefix, level:upper(), formatted)
end

local function output(level, message, ...)
    if not can_log(level) then
        return
    end

    local formatted = format_message(level, message, ...)

    if Console and Console.Log then
        Console.Log(level, formatted)
    else
        print(formatted)
    end
end

function Logger:set_level(level)
    if not self.levels[level] then
        return
    end
    self.minimum_level = self.levels[level]
end

function Logger:trace(message, ...)
    output("trace", message, ...)
end

function Logger:debug(message, ...)
    output("debug", message, ...)
end

function Logger:info(message, ...)
    output("info", message, ...)
end

function Logger:warn(message, ...)
    output("warn", message, ...)
end

function Logger:error(message, ...)
    output("error", message, ...)
end

function Logger:fatal(message, ...)
    output("fatal", message, ...)
end

return Logger
