--- @class TemporalConvergenceTracker : CooldownTracker
--- @field buffUp boolean
--- @field upUntil number
--- @diagnostic disable: duplicate-set-field
TemporalConvergenceTracker = setmetatable({}, { __index = CooldownTracker })
TemporalConvergenceTracker.__index = TemporalConvergenceTracker

--- @return TemporalConvergenceTracker
function TemporalConvergenceTracker.new()
    --- @class TemporalConvergenceTracker
    local self = CooldownTracker.new()
    setmetatable(self, TemporalConvergenceTracker)
    self.buffUp = Helpers:HasBuff("player", "Spell_Nature_StormReach")
    return self
end

function TemporalConvergenceTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.buffUp = Helpers:HasBuff("player", "Spell_Nature_StormReach")
end

--- @param event string
--- @param arg1 string
function TemporalConvergenceTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.buffUp = false
        self.upUntil = nil
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, PASSIVE_TEMPORAL_CONVERGENCE) then
        Logging:Debug(PASSIVE_TEMPORAL_CONVERGENCE .. " is up")
        self.buffUp = true
        self.upUntil = GetTime() + 12
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, PASSIVE_TEMPORAL_CONVERGENCE) then
        Logging:Debug(PASSIVE_TEMPORAL_CONVERGENCE .. " is down")
        self.buffUp = false
        self.upUntil = nil
    end
end

--- @return boolean
function TemporalConvergenceTracker:ShouldCast()
    return self.buffUp
end

--- @return number
function TemporalConvergenceTracker:TimeUntilBuffExpires()
    if self.buffUp and self.upUntil then
        return self.upUntil - GetTime()
    end
    return 0
end