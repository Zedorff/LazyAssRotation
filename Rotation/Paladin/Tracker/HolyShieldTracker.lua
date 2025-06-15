--- @class HolyShieldTracker : SelfBuffTracker
--- @field shieldIsUp boolean
--- @diagnostic disable: duplicate-set-field
HolyShieldTracker = setmetatable({}, { __index = SelfBuffTracker })
HolyShieldTracker.__index = HolyShieldTracker

--- @return HolyShieldTracker
function HolyShieldTracker.new()
    --- @class HolyShieldTracker
    local self = SelfBuffTracker.new(Abilities.HolyShield.name, "Spell_Holy_BlessingOfProtection")
    setmetatable(self, HolyShieldTracker)
    return self
end
