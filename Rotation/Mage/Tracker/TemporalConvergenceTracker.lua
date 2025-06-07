--- @class TemporalConvergenceTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
TemporalConvergenceTracker = setmetatable({}, { __index = SelfBuffTracker })
TemporalConvergenceTracker.__index = TemporalConvergenceTracker

--- @return TemporalConvergenceTracker
function TemporalConvergenceTracker.new()
    --- @class TemporalConvergenceTracker
    local self = SelfBuffTracker.new(PASSIVE_TEMPORAL_CONVERGENCE, "Spell_Nature_StormReach")
    setmetatable(self, TemporalConvergenceTracker)
    return self
end
