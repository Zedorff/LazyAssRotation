--- @class ArcaneRuptureTracker : CooldownTracker
--- @field ruptureIsUp boolean
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
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" and string.find(arg1, ABILITY_ARCANE_RUPTURE) then
        Logging:Debug(ABILITY_ARCANE_RUPTURE.." is up")
        self.ruptureIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_ARCANE_RUPTURE) then
        Logging:Debug(ABILITY_ARCANE_RUPTURE.." is down")
        self.ruptureIsUp = false
    end 
end

--- @return boolean
function ArcaneRuptureTracker:ShouldCast()
    return not self.ruptureIsUp
end
