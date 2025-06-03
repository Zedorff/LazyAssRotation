--- @class ArcaneRuptureTracker : CooldownTracker
--- @field ruptureIsUp boolean
--- @field ruptureIsUpUntill number
--- @diagnostic disable: duplicate-set-field
ArcaneRuptureTracker = setmetatable({}, { __index = CooldownTracker })
ArcaneRuptureTracker.__index = ArcaneRuptureTracker

--- @return ArcaneRuptureTracker
function ArcaneRuptureTracker.new()
    --- @class ArcaneRuptureTracker
    local self = CooldownTracker.new()
    setmetatable(self, ArcaneRuptureTracker)
    self.ruptureIsUp = Helpers:HasDebuff("player", "Spell_Arcane_Blast")
    self.ruptureIsUpUntill = 0
    return self
end

function ArcaneRuptureTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.ruptureIsUp = Helpers:HasDebuff("player", "Spell_Arcane_Blast")
    self.ruptureIsUpUntill = 0
end

--- @param event string
--- @param arg1 string
function ArcaneRuptureTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" and string.find(arg1, ABILITY_ARCANE_RUPTURE) then
        Logging:Debug(ABILITY_ARCANE_RUPTURE.." is up")
        self.ruptureIsUp = true
        self.ruptureIsUpUntill = GetTime() + 8
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_ARCANE_RUPTURE) then
        Logging:Debug(ABILITY_ARCANE_RUPTURE.." is down")
        self.ruptureIsUp = false
        self.ruptureIsUpUntill = 0
    end 
end

--- @return boolean
function ArcaneRuptureTracker:ShouldCast()
    return not self.ruptureIsUp
end

function ArcaneRuptureTracker:GetRuptureRemainingTime()
    return self.ruptureIsUpUntill - GetTime()
end
