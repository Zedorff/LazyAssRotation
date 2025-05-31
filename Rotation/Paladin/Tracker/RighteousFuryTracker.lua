--- @class RighteousFuryTracker : CooldownTracker
--- @field furyUp boolean
--- @diagnostic disable: duplicate-set-field
RighteousFuryTracker = setmetatable({}, { __index = CooldownTracker })
RighteousFuryTracker.__index = RighteousFuryTracker

--- @return RighteousFuryTracker
function RighteousFuryTracker.new()
    --- @class RighteousFuryTracker
    local self = CooldownTracker.new()
    setmetatable(self, RighteousFuryTracker)
    self.furyUp = Helpers:HasBuff("player", "Spell_Holy_SealOfFury")
    return self
end

function RighteousFuryTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.furyUp = Helpers:HasBuff("player", "Spell_Holy_SealOfFury")
end

--- @param event string
--- @param arg1 string
function RighteousFuryTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_RIGHTEOUS_FURY) then
        Logging:Debug(ABILITY_RIGHTEOUS_FURY.." is up")
        self.furyUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_RIGHTEOUS_FURY) then
        Logging:Debug(ABILITY_RIGHTEOUS_FURY.." is down")
        self.furyUp = false
    end
end

--- @return boolean
function RighteousFuryTracker:ShouldCast()
    return not self.furyUp;
end
