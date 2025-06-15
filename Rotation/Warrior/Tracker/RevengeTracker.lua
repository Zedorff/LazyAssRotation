--- @class RevengeTracker : CooldownTracker
--- @field revengeReadyUntil number
--- @diagnostic disable: duplicate-set-field
RevengeTracker = setmetatable({}, { __index = CooldownTracker })
RevengeTracker.__index = RevengeTracker

--- @return RevengeTracker
function RevengeTracker.new()
    --- @class RevengeTracker
    local self = CooldownTracker.new()
    setmetatable(self, RevengeTracker)
    self.revengeReadyUntil = 0
    return self
end

--- @param event string
--- @param arg1 string
function RevengeTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.revengeReadyUntil = 0;
    elseif (event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES") then
        if string.find(arg1, "You block") or string.find(arg1, "You parry") or string.find(arg1, "You dodge") then
            self.revengeReadyUntil = GetTime() + 4;
        end
    elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" and string.find(arg1, "%(.- blocked%)") then
        self.revengeReadyUntil = GetTime() + 4;
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
        local hit, crit, _, miss, _ = Helpers:ParseCombatEvent(Abilities.Revenge.name, arg1)
        if hit or crit or miss then
            self.revengeReadyUntil = 0;
        end
    end
end

--- @return boolean
function RevengeTracker:ShouldCast()
    return GetTime() < self.revengeReadyUntil and Helpers:SpellReady(Abilities.Revenge.name)
end
