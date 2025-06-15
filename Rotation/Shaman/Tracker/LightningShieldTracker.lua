--- @class LightningShieldTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
LightningShieldTracker = setmetatable({}, { __index = SelfBuffTracker })
LightningShieldTracker.__index = LightningShieldTracker

--- @return LightningShieldTracker
function LightningShieldTracker.new()
    --- @class LightningShieldTracker
    local self = SelfBuffTracker.new(Abilities.LightningShield.name, "Spell_Nature_LightningShield")
    setmetatable(self, LightningShieldTracker)
    return self
end
