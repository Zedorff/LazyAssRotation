--- @class DurationedSelfBuffTracker : CooldownTracker
--- @field buffUp boolean
--- @field upUntil number
--- @field duration number
--- @diagnostic disable: duplicate-set-field
DurationedSelfBuffTracker = setmetatable({}, { __index = CooldownTracker })
DurationedSelfBuffTracker.__index = DurationedSelfBuffTracker

--- @param abilityName string
--- @param buffTexture string
--- @param duration number
--- @return DurationedSelfBuffTracker
function DurationedSelfBuffTracker.new(abilityName, buffTexture, duration)
    --- @class DurationedSelfBuffTracker
    local self = CooldownTracker.new()
    setmetatable(self, DurationedSelfBuffTracker)

    self.abilityName = abilityName
    self.buffTexture = buffTexture
    self.buffUp = Helpers:HasBuff("player", buffTexture)
    self.duration = duration

    return self
end

function DurationedSelfBuffTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.buffUp = Helpers:HasBuff("player", self.buffTexture)
end

--- @param event string
--- @param arg1 string
function DurationedSelfBuffTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.buffUp = false
        self.upUntil = nil
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, self.abilityName) then
        Logging:Debug(self.abilityName .. " is up")
        self.buffUp = true
        self.upUntil = GetTime() + self.duration
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, self.abilityName) then
        Logging:Debug(self.abilityName .. " is down")
        self.buffUp = false
        self.upUntil = nil
    end
end

--- @return boolean
function DurationedSelfBuffTracker:ShouldCast()
    return self.buffUp
end

--- @return number
function DurationedSelfBuffTracker:TimeUntilBuffExpires()
    if self.buffUp and self.upUntil then
        return self.upUntil - GetTime()
    end
    return 0
end