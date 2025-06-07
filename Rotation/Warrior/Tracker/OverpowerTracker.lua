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
    if event == "PLAYER_DEAD" then
        self.overpowerReadyUntil = 0;
    elseif (event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF") then
        local _, _, _, _, dodge = Helpers:ParseCombatEvent(".+", arg1)
        if dodge or string.find(arg1, CHAT_AUTOATTACK_DODGE) then
            self.overpowerReadyUntil = GetTime() + 5;
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.overpowerReadyUntil = 0;
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
        local hit, crit, _, miss, _ = Helpers:ParseCombatEvent(ABILITY_OVERPOWER, arg1)
        if hit or crit or miss then
            self.overpowerReadyUntil = 0;
        end
    end
end

--- @return boolean
function OverpowerTracker:ShouldCast()
    return GetTime() < self.overpowerReadyUntil and Helpers:SpellReady(ABILITY_OVERPOWER)
end
