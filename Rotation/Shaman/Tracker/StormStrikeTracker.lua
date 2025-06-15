--- @class StormStrikeTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
StormStrikeTracker = setmetatable({}, { __index = SelfBuffTracker })
StormStrikeTracker.__index = StormStrikeTracker

--- @return StormStrikeTracker
function StormStrikeTracker.new()
    --- @class StormStrikeTracker
    local self = SelfBuffTracker.new(Abilities.Stormstrike.name, "Ability_Hunter_RunningShot")
    setmetatable(self, StormStrikeTracker)
    return self
end
