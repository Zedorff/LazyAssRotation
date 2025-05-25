--- @class SealOfCrusaderSelfTracker : CooldownTracker
--- @field socrIsUp boolean
--- @diagnostic disable: duplicate-set-field
SealOfCrusaderSelfTracker = setmetatable({}, { __index = CooldownTracker })
SealOfCrusaderSelfTracker.__index = SealOfCrusaderSelfTracker

--- @return SealOfCrusaderSelfTracker
function SealOfCrusaderSelfTracker.new()
    --- @class SealOfCrusaderSelfTracker
    local self = CooldownTracker.new()
    setmetatable(self, SealOfCrusaderSelfTracker)
    self.socrIsUp = Helpers:HasBuffName("player", ABILITY_SEAL_CRUSADER)
    return self
end

function SealOfCrusaderSelfTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.socrIsUp = Helpers:HasBuffName("player", ABILITY_SEAL_CRUSADER)
end

--- @param event string
--- @param arg1 string
function SealOfCrusaderSelfTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_SEAL_CRUSADER) then
        Logging:Debug(ABILITY_SEAL_CRUSADER.." is up")
        self.socrIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_SEAL_CRUSADER) then
        Logging:Debug(ABILITY_SEAL_CRUSADER.." is down")
        self.socrIsUp = false
    end
end

--- @return boolean
function SealOfCrusaderSelfTracker:ShouldCast()
    return not self.socrIsUp;
end
