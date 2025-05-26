--- @class CooldownTracker : EventSubscriber
CooldownTracker = {}
CooldownTracker.__index = CooldownTracker

--- @return CooldownTracker
function CooldownTracker.new()
    return setmetatable({}, CooldownTracker)
end

--- @return boolean
function CooldownTracker:ShouldCast()
    error("ShouldCast() not implemented")
end

function CooldownTracker:subscribe()
    Logging:Debug("[Module Test]: subscribe tracker")
    Core.eventBus:subscribe(self)
end

function CooldownTracker:unsubscribe()
    Logging:Debug("[Module Test]: unsubscribe tracker")
    Core.eventBus:unsubscribe(self)
end

--- @param event string
--- @param arg1 string
function CooldownTracker:onEvent(event, arg1)
    error("onEvent() not implemented")
end
