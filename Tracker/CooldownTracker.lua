--- @class CooldownTracker
CooldownTracker = {}
CooldownTracker.__index = CooldownTracker

--- @return boolean
function CooldownTracker:isAvailable()
    error("isAvailable() not implemented")
end

--- @return number
function CooldownTracker:GetWhenAvailable()
    error("GetWhenAvailable() not implemented")
end