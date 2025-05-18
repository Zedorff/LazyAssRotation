--- @class CooldownTracker
CooldownTracker = {}
CooldownTracker.__index = CooldownTracker

--- @param event string
function CooldownTracker:onEvent(event)
    error("execute() not implemented")
end

--- @return boolean
function CooldownTracker:isAvailable()
    error("isAvailable() not implemented")
end

--- @return number
function CooldownTracker:GetWhenAvailable()
    error("GetWhenAvailable() not implemented")
end