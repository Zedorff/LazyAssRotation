--- @class HolyStrikeTracker : CooldownTracker
--- @field holyMightIsUp boolean
--- @field lastHolyMightApply number
--- @diagnostic disable: duplicate-set-field
HolyStrikeTracker = setmetatable({}, { __index = CooldownTracker })
HolyStrikeTracker.__index = HolyStrikeTracker

--- @return HolyStrikeTracker
function HolyStrikeTracker.new()
    --- @class HolyStrikeTracker
    local self = CooldownTracker.new()
    setmetatable(self, HolyStrikeTracker)
    self.holyMightIsUp = Helpers:HasBuff("player", "Spell_Holy_HolyNova")
    self.lastHolyMightApply = GetTime() + 6
    return self
end

function HolyStrikeTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.holyMightIsUp = Helpers:HasBuff("player", "Spell_Holy_HolyNova")
    self.lastHolyMightApply = GetTime() + 6
end

--- @param event string
--- @param arg1 string
function HolyStrikeTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, "Holy Might") then
        Logging:Debug("Holy Might is up")
        self.holyMightIsUp = true
        self.lastHolyMightApply = GetTime() + 20
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, "Holy Might") then
        Logging:Debug("Holy Might is down")
        self.holyMightIsUp = false
        self.lastHolyMightApply = 0
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, ABILITY_HOLY_STRIKE) then
        self.holyMightIsUp = true
        self.lastHolyMightApply = GetTime() + 20
    end
end

--- @return boolean
function HolyStrikeTracker:ShouldCast()
    return not self.holyMightIsUp or self.lastHolyMightApply < (GetTime() + 6) -- re-apply before fade
end
