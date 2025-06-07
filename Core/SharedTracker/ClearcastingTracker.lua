--- @class ClearcastingTracker : SelfBuffTracker
--- @field buffIsUp boolean
--- @diagnostic disable: duplicate-set-field
ClearcastingTracker = setmetatable({}, { __index = SelfBuffTracker })
ClearcastingTracker.__index = ClearcastingTracker

--- @return ClearcastingTracker
function ClearcastingTracker.new()
    --- @class ClearcastingTracker
    local self = SelfBuffTracker.new(PASSIVE_CLEARCASTING, "Spell_Shadow_ManaBurn")
    setmetatable(self, ClearcastingTracker)
    return self
end
