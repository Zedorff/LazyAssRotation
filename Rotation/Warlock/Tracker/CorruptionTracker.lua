--- @class CorruptionTracker : WarlockDotTracker
CorruptionTracker = setmetatable({}, { __index = WarlockDotTracker })
CorruptionTracker.__index = CorruptionTracker

--- @return CorruptionTracker
function CorruptionTracker.new()
    --- @class CorruptionTracker
    local self = WarlockDotTracker.new(ABILITY_CORRUPTION, ABILITY_CORRUPTION)
    setmetatable(self, CorruptionTracker)
    return self
end
