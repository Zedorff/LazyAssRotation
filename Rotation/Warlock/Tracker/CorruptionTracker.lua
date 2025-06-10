--- @class CorruptionTracker : WarlockDotTracker
CorruptionTracker = setmetatable({}, { __index = WarlockDotTracker })
CorruptionTracker.__index = CorruptionTracker

--- @type CorruptionTracker | nil
local sharedInstance = nil

--- @return CorruptionTracker
function CorruptionTracker.GetInstance()
    -- if sharedInstance then
        -- return sharedInstance
    -- end
    --- @class CorruptionTracker
    local self = WarlockDotTracker.new(ABILITY_CORRUPTION, ABILITY_CORRUPTION)
    setmetatable(self, CorruptionTracker)

    sharedInstance = self
    return sharedInstance
end
