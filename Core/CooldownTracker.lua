MLDps = MLDps or {}
local global = MLDps

--- @class CooldownTracker
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
    global.eventBus:subscribe(self)
end

function CooldownTracker:unsubscribe()
    global.eventBus:unsubscribe(self)
end

--- @param event string
--- @param arg1 string
function CooldownTracker:onEvent(event, arg1)
    error("onEvent() not implemented")
end
