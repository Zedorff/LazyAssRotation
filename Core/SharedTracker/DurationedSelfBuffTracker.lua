--- @class DurationedSelfBuffTracker : CooldownTracker
--- @field buffUp boolean
--- @field upUntil number
--- @field duration number
--- @field buffApi BuffApi
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

    local buffApi = BuffApiFactory.GetInstance()
    self.abilityName = abilityName
    self.buffTexture = buffTexture
    self.buffApi = buffApi
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
function DurationedSelfBuffTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "PLAYER_DEAD" then
        self.buffUp = false
        self.upUntil = nil
        return
    end
    self.buffApi:OnDurationedSelfBuffEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
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