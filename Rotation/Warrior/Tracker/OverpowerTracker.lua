--- @class OverpowerTracker : CooldownTracker
--- @field overpowerReadyUntil number
--- @diagnostic disable: duplicate-set-field
OverpowerTracker = setmetatable({}, { __index = CooldownTracker })
OverpowerTracker.__index = OverpowerTracker

--- @return OverpowerTracker
function OverpowerTracker.new()
    --- @class OverpowerTracker
    local self = CooldownTracker.new()
    setmetatable(self, OverpowerTracker)
    self.overpowerReadyUntil = 0
    return self
end

--- @param event string
--- @param arg1 string
function OverpowerTracker:onEvent(event, arg1)
    if (event == "CHAT_MSG_COMBAT_SELF_MISSES"
            or event == "CHAT_MSG_SPELL_SELF_DAMAGE"
            or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
        and (string.find(arg1, CHAT_DODGE_OVERPOWER) or string.find(arg1, CHAT_DODGE_OVERPOWER2)) then
        self.overpowerReadyUntil = GetTime() + 5;
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.overpowerReadyUntil = 0;
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE"
        and (string.find(arg1, CHAT_OVERPOWER1)
            or string.find(arg1, CHAT_OVERPOWER2)
            or string.find(arg1, CHAT_OVERPOWER3)) then
        self.overpowerReadyUntil = 0;
    end
end

--- @return boolean
function OverpowerTracker:isAvailable()
    return GetTime() < self.overpowerReadyUntil and Helpers:SpellReady(ABILITY_OVERPOWER)
end

--- @return number
function OverpowerTracker:GetWhenAvailable()
    return self.overpowerReadyUntil;
end
