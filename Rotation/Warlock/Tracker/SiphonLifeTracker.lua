--- @class SiphonLifeTracker : WarlockDotTracker
SiphonLifeTracker = setmetatable({}, { __index = WarlockDotTracker })
SiphonLifeTracker.__index = SiphonLifeTracker

--- @type SiphonLifeTracker | nil
local sharedInstance = nil

--- @return SiphonLifeTracker
function SiphonLifeTracker.GetInstance()
    if sharedInstance then
        return sharedInstance
    end

    --- @class SiphonLifeTracker
    local self = WarlockDotTracker.new(18881, ABILITY_SIPHON_LIFE)
    setmetatable(self, SiphonLifeTracker)

    sharedInstance = self

    return sharedInstance
end
