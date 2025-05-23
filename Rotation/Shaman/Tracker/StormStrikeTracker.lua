MLDps = MLDps or {}

--- @class StormStrikeTracker : CooldownTracker
--- @field buffIsUp boolean
--- @diagnostic disable: duplicate-set-field
StormStrikeTracker = setmetatable({}, { __index = CooldownTracker })
StormStrikeTracker.__index = StormStrikeTracker

function StormStrikeTracker.new()
    local obj = {
        buffIsUp = Helpers:HasBuff("player", "Ability_Warrior_ThunderClap")
    }

    return setmetatable(obj, StormStrikeTracker)
end

function StormStrikeTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.buffIsUp = Helpers:HasBuff("player", "Ability_Warrior_ThunderClap")
end

--- @param event string
--- @param arg1 string
function StormStrikeTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_STORMSTRIKE) then
        Logging:Debug("Storm Strike is up")
        self.buffIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_STORMSTRIKE) then
        Logging:Debug("Storm Strike is down")
        self.buffIsUp = false
    end 
end

--- @return boolean
function StormStrikeTracker:isAvailable()
    return not self.buffIsUp
end

--- @return number
function StormStrikeTracker:GetWhenAvailable()
    return 0;
end
