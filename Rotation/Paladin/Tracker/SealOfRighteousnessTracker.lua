--- @class SealOfRighteousnessTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
SealOfRighteousnessTracker = setmetatable({}, { __index = SelfBuffTracker })
SealOfRighteousnessTracker.__index = SealOfRighteousnessTracker

--- @return SealOfRighteousnessTracker
function SealOfRighteousnessTracker.new()
    --- @class SealOfRighteousnessTracker
    local self = SelfBuffTracker.new(ABILITY_SEAL_RIGHTEOUSNESS, "Ability_ThunderBolt")
    setmetatable(self, SealOfRighteousnessTracker)
    return self
end
