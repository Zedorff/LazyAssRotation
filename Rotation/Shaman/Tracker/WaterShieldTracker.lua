--- @class WaterShieldTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
WaterShieldTracker = setmetatable({}, { __index = SelfBuffTracker })
WaterShieldTracker.__index = WaterShieldTracker

--- @return WaterShieldTracker
function WaterShieldTracker.new()
    --- @class WaterShieldTracker
    local self = SelfBuffTracker.new(ABILITY_WATER_SHIELD, "Ability_Shaman_WaterShield")
    setmetatable(self, WaterShieldTracker)
    return self
end
