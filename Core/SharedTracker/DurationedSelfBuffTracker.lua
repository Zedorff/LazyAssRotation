--- @class DurationedSelfBuffTracker : CooldownTracker
--- @field buffUp boolean
--- @field upUntil number
--- @field duration number
--- @field buffPipeline BuffEventPipeline
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

    local buffPipeline = BuffApiFactory.GetInstance()
    self.abilityName = abilityName
    self.buffTexture = buffTexture
    self.buffPipeline = buffPipeline
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
    self.buffPipeline:ApplyDurationedSelfBuffEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, function(msg)
        if not msg then
            return
        end
        if msg.kind == BuffPipelineKind.BUFF_UP then
            Logging:Debug(self.abilityName .. " is up")
            self.buffUp = true
            self.upUntil = GetTime() + (msg.durationSec or self.duration)
        else
            Logging:Debug(self.abilityName .. (msg.via_chat and " is down (chat)" or " is down"))
            self.buffUp = false
            self.upUntil = nil
        end
    end)
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