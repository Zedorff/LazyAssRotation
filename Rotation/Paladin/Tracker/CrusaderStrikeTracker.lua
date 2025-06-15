--- @class CrusaderStrikeTracker : CooldownTracker
--- @field zealStacks integer
--- @field lastZealApply number
--- @diagnostic disable: duplicate-set-field
CrusaderStrikeTracker = setmetatable({}, { __index = CooldownTracker })
CrusaderStrikeTracker.__index = CrusaderStrikeTracker

--- @return CrusaderStrikeTracker
function CrusaderStrikeTracker.new()
    --- @class CrusaderStrikeTracker
    local self = CooldownTracker.new()
    setmetatable(self, CrusaderStrikeTracker)

    self.zealStacks = Helpers:GetBuffStackCount("player", "Spell_Holy_CrusaderStrike")
    self.lastZealApply = GetTime() + 6

    return self
end

function CrusaderStrikeTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.zealStacks = Helpers:GetBuffStackCount("player", "Spell_Holy_CrusaderStrike")
    self.lastZealApply = GetTime() + 6
end

--- @param event string
--- @param arg1 string
function CrusaderStrikeTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.zealStacks = 0
        self.lastZealApply = 0
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, "Zeal") then
        Logging:Debug("Zeal is up")
        if self.zealStacks < 3 then
           self.zealStacks = self.zealStacks + 1
        end
        self.lastZealApply = GetTime() + 30
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, "Zeal") then
        Logging:Debug("Zeal is down")
        self.zealStacks = 0
        self.lastZealApply = 0
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, Abilities.CrusaderStrike.name) then
        self.lastZealApply = GetTime() + 30
    end
end

--- @return boolean
function CrusaderStrikeTracker:ShouldCast()
    return self.zealStacks < 3 or self.lastZealApply < (GetTime() + 6) -- re-apply before fade
end
