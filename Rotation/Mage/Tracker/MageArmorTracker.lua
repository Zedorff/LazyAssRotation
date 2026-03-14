--- @class MageArmorTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
MageArmorTracker = setmetatable({}, { __index = SelfBuffTracker })
MageArmorTracker.__index = MageArmorTracker

--- @return MageArmorTracker
function MageArmorTracker.new()
    --- @class MageArmorTracker
    local self = SelfBuffTracker.new(Abilities.MageArmor.name, "Spell_MageArmor")
    setmetatable(self, MageArmorTracker)
    return self
end
