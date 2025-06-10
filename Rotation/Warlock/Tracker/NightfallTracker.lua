--- @class NightfallTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
NightfallTracker = setmetatable({}, { __index = SelfBuffTracker })
NightfallTracker.__index = NightfallTracker

--- @return NightfallTracker
function NightfallTracker.new()
    --- @class NightfallTracker
    local self = SelfBuffTracker.new(PASSIVE_NIGHTFALL, "Spell_Shadow_Twilight")
    setmetatable(self, NightfallTracker)
    return self
end

--- @return boolean
function NightfallTracker:ShouldCast()
    return self.buffUp
end
