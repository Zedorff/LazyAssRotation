--- @class CooldownTracker : Tracker
--- @field _refCount integer
CooldownTracker = setmetatable({}, { __index = Tracker })
CooldownTracker.__index = CooldownTracker

--- @return CooldownTracker
function CooldownTracker.new()
    --- @class CooldownTracker
    local self = Tracker.new()
    setmetatable(self, CooldownTracker)
    return self
end

--- @return boolean
function CooldownTracker:ShouldCast()
    error("ShouldCast() not implemented")
end
