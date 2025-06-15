--- @class SealOfCommandTracker : SelfBuffTracker
--- @field socIsUp boolean
--- @diagnostic disable: duplicate-set-field
SealOfCommandTracker = setmetatable({}, { __index = SelfBuffTracker })
SealOfCommandTracker.__index = SealOfCommandTracker

--- @return SealOfCommandTracker
function SealOfCommandTracker.new()
    --- @class SealOfCommandTracker
    local self = SelfBuffTracker.new(Abilities.SealCommand.name, "Ability_Warrior_InnerRage")
    setmetatable(self, SealOfCommandTracker)
    return self
end
