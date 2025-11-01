--- @class TemporalConvergenceTracker : DurationedSelfBuffTracker
--- @diagnostic disable: duplicate-set-field
TemporalConvergenceTracker = setmetatable({}, { __index = DurationedSelfBuffTracker })
TemporalConvergenceTracker.__index = TemporalConvergenceTracker

--- @return TemporalConvergenceTracker
function TemporalConvergenceTracker.new()
    --- @class TemporalConvergenceTracker
    local self = DurationedSelfBuffTracker.new(PASSIVE_TEMPORAL_CONVERGENCE, "Spell_Nature_StormReach", 12)
    setmetatable(self, TemporalConvergenceTracker)
    return self
end
