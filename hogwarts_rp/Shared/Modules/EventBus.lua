local Logger = Package.Require("Shared/Modules/Logger.lua")

local EventBus = {}
EventBus._listeners = {}

function EventBus:subscribe(event_name, handler)
    if not self._listeners[event_name] then
        self._listeners[event_name] = {}
    end

    table.insert(self._listeners[event_name], handler)
    Logger:debug("EventBus: suscrito handler a '%s'", event_name)

    return function()
        local listeners = self._listeners[event_name]
        if not listeners then
            return
        end

        for index, registered in ipairs(listeners) do
            if registered == handler then
                table.remove(listeners, index)
                Logger:debug("EventBus: desuscrito handler de '%s'", event_name)
                break
            end
        end
    end
end

function EventBus:emit(event_name, ...)
    local listeners = self._listeners[event_name]
    if not listeners then
        return
    end

    for _, handler in ipairs(listeners) do
        local ok, err = pcall(handler, ...)
        if not ok then
            Logger:error("EventBus: error en handler '%s': %s", event_name, err)
        end
    end
end

return EventBus
