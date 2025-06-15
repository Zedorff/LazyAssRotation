--- @class ArcanePowerTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
ArcanePowerTracker = setmetatable({}, { __index = SelfBuffTracker })
ArcanePowerTracker.__index = ArcanePowerTracker

--- @return ArcanePowerTracker
function ArcanePowerTracker.new()
    --- @class ArcanePowerTracker
    local self = SelfBuffTracker.new(Abilities.ArcanePower.name, "Spell_Nature_Lightning")
    setmetatable(self, ArcanePowerTracker)
    return self
end
