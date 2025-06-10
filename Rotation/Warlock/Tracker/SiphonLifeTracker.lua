--- @class SiphonLifeTracker : WarlockDotTracker
SiphonLifeTracker = setmetatable({}, { __index = WarlockDotTracker })
SiphonLifeTracker.__index = SiphonLifeTracker

--- @return SiphonLifeTracker
function SiphonLifeTracker.new()
    --- @class SiphonLifeTracker
    local self = WarlockDotTracker.new(ABILITY_SIPHON_LIFE, ABILITY_SIPHON_LIFE)
    setmetatable(self, SiphonLifeTracker)
    return self
end
