local EventBus = {}
EventBus._events = EventBus._events or {}

function EventBus:Subscribe(event, handler)
    self._events[event] = self._events[event] or {}
    table.insert(self._events[event], handler)
    return handler
end

function EventBus:Unsubscribe(event, handler)
    if not self._events[event] then return end
    for index, stored in ipairs(self._events[event]) do
        if stored == handler then
            table.remove(self._events[event], index)
            break
        end
    end
end

function EventBus:Emit(event, ...)
    if not self._events[event] then return end
    for _, handler in ipairs(self._events[event]) do
        local ok, err = pcall(handler, ...)
        if not ok then
            if Hogwarts.Core.Logger then
                Hogwarts.Core.Logger:Error("Event '%s' handler error: %s", event, err)
            else
                ErrorNoHalt(string.format("[Hogwarts] Event '%s' handler error: %s\n", event, err))
            end
        end
    end
end

Hogwarts.Core.EventBus = EventBus

return EventBus
