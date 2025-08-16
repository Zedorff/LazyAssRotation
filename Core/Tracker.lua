--- @class Tracker : EventSubscriber
--- @field _refCount integer
Tracker = {}
Tracker.__index = Tracker

--- @return Tracker
function Tracker.new()
    local self = {
        _refCount = 0
    }
    return setmetatable(self, Tracker)
end

function Tracker:subscribe()
    self._refCount = self._refCount + 1
    if self._refCount == 1 then
        Core.eventBus:subscribe(self)
    end
end

function Tracker:unsubscribe()
    if self._refCount == 0 then return end
    self._refCount = self._refCount - 1
    if self._refCount == 0 then
        Core.eventBus:unsubscribe(self)
    end
end

--- @param event string
--- @param arg1 string
function Tracker:onEvent(event, arg1)
    error("onEvent() not implemented")
end
