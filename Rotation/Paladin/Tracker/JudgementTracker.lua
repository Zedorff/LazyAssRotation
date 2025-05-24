--- @class JudgementTracker : CooldownTracker
--- @field hasSeal boolean
--- @diagnostic disable: duplicate-set-field
JudgementTracker = setmetatable({}, { __index = CooldownTracker })
JudgementTracker.__index = JudgementTracker

--- @return JudgementTracker
function JudgementTracker.new()
    --- @class JudgementTracker
    local self = CooldownTracker.new()
    setmetatable(self, JudgementTracker)
    self.hasSeal = Helpers:HasBuff("player", "Spell_Holy_RighteousnessAura")
    return self
end

function JudgementTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.hasSeal = Helpers:HasBuff("target", "Spell_Holy_RighteousnessAura")
end

--- @param event string
--- @param arg1 string
function JudgementTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, "Seal") then
        Logging:Debug("Seal spell is up")
        self.hasSeal = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, "Seal") then
        Logging:Debug("Seal spell is down")
        self.hasSeal = false
    end 
end

--- @return boolean
function JudgementTracker:ShouldCast()
    return self.hasSeal;
end
