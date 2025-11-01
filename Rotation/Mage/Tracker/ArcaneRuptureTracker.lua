--- @class ArcaneRuptureTracker : CooldownTracker
--- @field ruptureIsUp boolean
--- @field upUntil number
--- @diagnostic disable: duplicate-set-field
ArcaneRuptureTracker = setmetatable({}, { __index = CooldownTracker })
ArcaneRuptureTracker.__index = ArcaneRuptureTracker

--- @return ArcaneRuptureTracker
function ArcaneRuptureTracker.new()
    --- @class ArcaneRuptureTracker
    local self = CooldownTracker.new()
    setmetatable(self, ArcaneRuptureTracker)
    self.ruptureIsUp = Helpers:HasDebuff("player", "Spell_Arcane_Blast")
    return self
end

function ArcaneRuptureTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.ruptureIsUp = Helpers:HasDebuff("player", "Spell_Arcane_Blast")
end

--- @param event string
--- @param arg1 string
function ArcaneRuptureTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.ruptureIsUp = false
        self.upUntil = nil
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" and string.find(arg1, Abilities.ArcaneRupture.name) then
        Logging:Debug(Abilities.ArcaneRupture.name.." is up")
        self.ruptureIsUp = true
        self.upUntil = GetTime() + 8
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, Abilities.ArcaneRupture.name) then
        Logging:Debug(Abilities.ArcaneRupture.name.." is down")
        self.ruptureIsUp = false
        self.upUntil = nil
    end 
end

--- @return boolean
function ArcaneRuptureTracker:ShouldCast()
    return not self.ruptureIsUp
end

--- @return number
function ArcaneRuptureTracker:TimeUntilRuptureExpires()
    if self.ruptureIsUp and self.upUntil then
        return self.upUntil - GetTime()
    end
    return 0
end
