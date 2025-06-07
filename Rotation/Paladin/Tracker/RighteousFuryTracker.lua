--- @class RighteousFuryTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
RighteousFuryTracker = setmetatable({}, { __index = SelfBuffTracker })
RighteousFuryTracker.__index = RighteousFuryTracker

--- @return RighteousFuryTracker
function RighteousFuryTracker.new()
    --- @class RighteousFuryTracker
    local self = SelfBuffTracker.new(ABILITY_RIGHTEOUS_FURY, "Spell_Holy_SealOfFury")
    setmetatable(self, RighteousFuryTracker)
    return self
end
