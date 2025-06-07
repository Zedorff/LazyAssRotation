--- @class SealOfWisdomSelfTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
SealOfWisdomSelfTracker = setmetatable({}, { __index = SelfBuffTracker })
SealOfWisdomSelfTracker.__index = SealOfWisdomSelfTracker

--- @return SealOfWisdomSelfTracker
function SealOfWisdomSelfTracker.new()
    --- @class SealOfWisdomSelfTracker
    local self = SelfBuffTracker.new(ABILITY_SEAL_WISDOM, "Spell_Holy_RighteousnessAura")
    setmetatable(self, SealOfWisdomSelfTracker)
    return self
end
