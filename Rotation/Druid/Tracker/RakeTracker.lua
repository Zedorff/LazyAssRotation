--- @class RakeTracker : DotTracker
RakeTracker = setmetatable({}, { __index = DotTracker })
RakeTracker.__index = RakeTracker

--- @return RakeTracker
function RakeTracker.new()
    --- @class RakeTracker
    local self = DotTracker.new(9904, ABILITY_RAKE)
    setmetatable(self, RakeTracker)
    return self
end
