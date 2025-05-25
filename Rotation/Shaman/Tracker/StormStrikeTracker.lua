--- @class StormStrikeTracker : CooldownTracker
--- @field buffIsUp boolean
--- @diagnostic disable: duplicate-set-field
StormStrikeTracker = setmetatable({}, { __index = CooldownTracker })
StormStrikeTracker.__index = StormStrikeTracker

--- @return StormStrikeTracker
function StormStrikeTracker.new()
    --- @class StormStrikeTracker
    local self = CooldownTracker.new()
    setmetatable(self, StormStrikeTracker)
    self.buffIsUp = Helpers:HasBuffName("player", ABILITY_STORMSTRIKE)
    return self
end

function StormStrikeTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.buffIsUp = Helpers:HasBuffName("player", ABILITY_STORMSTRIKE)
end

--- @param event string
--- @param arg1 string
function StormStrikeTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_STORMSTRIKE) then
        Logging:Debug(ABILITY_STORMSTRIKE.." is up")
        self.buffIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_STORMSTRIKE) then
        Logging:Debug(ABILITY_STORMSTRIKE.." is down")
        self.buffIsUp = false
    end
end

--- @return boolean
function StormStrikeTracker:ShouldCast()
    return not self.buffIsUp
end
