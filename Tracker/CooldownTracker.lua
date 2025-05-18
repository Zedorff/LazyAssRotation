CooldownTracker = {}
CooldownTracker.__index = CooldownTracker

function CooldownTracker:onEvent(event)
    error("execute() not implemented")
end

function CooldownTracker:isAvailable()
    error("isAvailable() not implemented")
end

function CooldownTracker:GetWhenAvailable()
    error("GetWhenAvailable() not implemented")
end