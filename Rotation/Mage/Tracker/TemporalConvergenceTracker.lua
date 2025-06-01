--- @class TemporalConvergenceTracker : CooldownTracker
--- @field convergenceIsUp boolean
--- @diagnostic disable: duplicate-set-field
TemporalConvergenceTracker = setmetatable({}, { __index = CooldownTracker })
TemporalConvergenceTracker.__index = TemporalConvergenceTracker

--- @return TemporalConvergenceTracker
function TemporalConvergenceTracker.new()
    --- @class TemporalConvergenceTracker
    local self = CooldownTracker.new()
    setmetatable(self, TemporalConvergenceTracker)
    self.convergenceIsUp = Helpers:HasBuff("player", "Spell_Nature_StormReach")
    return self
end

function TemporalConvergenceTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.convergenceIsUp = Helpers:HasBuff("player", "Spell_Nature_StormReach")
end

--- @param event string
--- @param arg1 string
function TemporalConvergenceTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, PASSIVE_TEMPORAL_CONVERGENCE) then
        Logging:Debug(PASSIVE_TEMPORAL_CONVERGENCE.." is up")
        self.convergenceIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, PASSIVE_TEMPORAL_CONVERGENCE) then
        Logging:Debug(PASSIVE_TEMPORAL_CONVERGENCE.." is down")
        self.convergenceIsUp = false
    end 
end

--- @return boolean
function TemporalConvergenceTracker:ShouldCast()
    return self.convergenceIsUp
end
