--- @class SealOfCrusaderSelfTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
SealOfCrusaderSelfTracker = setmetatable({}, { __index = SelfBuffTracker })
SealOfCrusaderSelfTracker.__index = SealOfCrusaderSelfTracker

--- @return SealOfCrusaderSelfTracker
function SealOfCrusaderSelfTracker.new()
    --- @class SealOfCrusaderSelfTracker
    local self = SelfBuffTracker.new(Abilities.SealCrusader.name, "Spell_Holy_HolySmite")
    setmetatable(self, SealOfCrusaderSelfTracker)
    return self
end
