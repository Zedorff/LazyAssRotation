--- @class RipTracker : DotTracker
RipTracker = setmetatable({}, { __index = DotTracker })
RipTracker.__index = RipTracker

--- @return RipTracker
function RipTracker.new()
    --- @class RipTracker
    local self = DotTracker.new(Abilities.Rip)
    setmetatable(self, RipTracker)
    return self
end
