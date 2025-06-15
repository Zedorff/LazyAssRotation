--- @class ShieldBlockTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
ShieldBlockTracker = setmetatable({}, { __index = SelfBuffTracker })
ShieldBlockTracker.__index = ShieldBlockTracker

--- @return ShieldBlockTracker
function ShieldBlockTracker.new()
    --- @class ShieldBlockTracker
    local self = SelfBuffTracker.new(Abilities.ShieldBlock.name, "Ability_Defend")
    setmetatable(self, ShieldBlockTracker)
    return self
end
