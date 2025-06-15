--- @class SealOfRighteousnessTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
SealOfRighteousnessTracker = setmetatable({}, { __index = SelfBuffTracker })
SealOfRighteousnessTracker.__index = SealOfRighteousnessTracker

--- @return SealOfRighteousnessTracker
function SealOfRighteousnessTracker.new()
    --- @class SealOfRighteousnessTracker
    local self = SelfBuffTracker.new(Abilities.SealRighteousness.name, "Ability_ThunderBolt")
    setmetatable(self, SealOfRighteousnessTracker)
    return self
end
