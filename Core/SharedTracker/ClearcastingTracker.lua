--- @class ClearcastingTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
ClearcastingTracker = setmetatable({}, { __index = SelfBuffTracker })
ClearcastingTracker.__index = ClearcastingTracker

--- @type ClearcastingTracker | nil
local sharedInstance = nil

--- @return ClearcastingTracker
function ClearcastingTracker.GetInstance()
    if sharedInstance then
        return sharedInstance
    end

    --- @class ClearcastingTracker
    local self = SelfBuffTracker.new(PASSIVE_CLEARCASTING, "Spell_Shadow_ManaBurn")
    setmetatable(self, ClearcastingTracker)

    sharedInstance = self

    return sharedInstance
end

--- @return boolean
function ClearcastingTracker:ShouldCast()
    return self.buffUp
end
