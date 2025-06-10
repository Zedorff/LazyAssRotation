--- @class CooldownTracker : EventSubscriber
--- @field _refCount integer
CooldownTracker = {}
CooldownTracker.__index = CooldownTracker

--- @return CooldownTracker
function CooldownTracker.new()
    local self = {
        _refCount = 0
    }
    return setmetatable(self, CooldownTracker)
end

--- @return boolean
function CooldownTracker:ShouldCast()
    error("ShouldCast() not implemented")
end

function CooldownTracker:subscribe()
    self._refCount = self._refCount + 1
    if self._refCount == 1 then
        Core.eventBus:subscribe(self)
    end
end

function CooldownTracker:unsubscribe()
    if self._refCount == 0 then return end
    self._refCount = self._refCount - 1
    if self._refCount == 0 then
        Core.eventBus:unsubscribe(self)
    end
end

--- @param event string
--- @param arg1 string
function CooldownTracker:onEvent(event, arg1)
    error("onEvent() not implemented")
end
