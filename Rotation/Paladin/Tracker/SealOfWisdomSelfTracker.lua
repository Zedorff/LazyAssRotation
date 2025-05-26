--- @class SealOfWisdomSelfTracker : CooldownTracker
--- @field sowIsUp boolean
--- @diagnostic disable: duplicate-set-field
SealOfWisdomSelfTracker = setmetatable({}, { __index = CooldownTracker })
SealOfWisdomSelfTracker.__index = SealOfWisdomSelfTracker

--- @return SealOfWisdomSelfTracker
function SealOfWisdomSelfTracker.new()
    --- @class SealOfWisdomSelfTracker
    local self = CooldownTracker.new()
    setmetatable(self, SealOfWisdomSelfTracker)
    self.sowIsUp = Helpers:HasBuff("player", "Spell_Holy_RighteousnessAura")
    return self
end

function SealOfWisdomSelfTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.sowIsUp = Helpers:HasBuff("player", "Spell_Holy_RighteousnessAura")
end

--- @param event string
--- @param arg1 string
function SealOfWisdomSelfTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_SEAL_WISDOM) then
        Logging:Debug(ABILITY_SEAL_WISDOM.." is up")
        self.sowIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_SEAL_WISDOM) then
        Logging:Debug(ABILITY_SEAL_WISDOM.." is down")
        self.sowIsUp = false
    end
end

--- @return boolean
function SealOfWisdomSelfTracker:ShouldCast()
    return not self.sowIsUp;
end
