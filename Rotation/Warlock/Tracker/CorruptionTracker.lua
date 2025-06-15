--- @class CorruptionTracker : WarlockDotTracker
CorruptionTracker = setmetatable({}, { __index = WarlockDotTracker })
CorruptionTracker.__index = CorruptionTracker

--- @type CorruptionTracker | nil
local _sharedInstance = nil

--- @return CorruptionTracker
function CorruptionTracker.GetInstance()
    if _sharedInstance then
        return _sharedInstance
    end
    --- @class CorruptionTracker
    local self = WarlockDotTracker.new(Abilities.Corruption)
    setmetatable(self, CorruptionTracker)

    _sharedInstance = self
    return _sharedInstance
end
