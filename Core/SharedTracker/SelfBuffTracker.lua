--- @class SelfBuffTracker : CooldownTracker
--- @field abilityName string
--- @field buffTexture string
--- @field buffUp boolean
--- @field buffPipeline BuffEventPipeline
SelfBuffTracker = setmetatable({}, { __index = CooldownTracker })
SelfBuffTracker.__index = SelfBuffTracker

--- @param abilityName string
--- @param buffTexture string
--- @return SelfBuffTracker
function SelfBuffTracker.new(abilityName, buffTexture)
    --- @class SelfBuffTracker
    local self = CooldownTracker.new()
    setmetatable(self, SelfBuffTracker)

    local buffPipeline = BuffApiFactory.GetInstance()
    self.abilityName = abilityName
    self.buffTexture = buffTexture
    self.buffPipeline = buffPipeline
    self.buffUp = Helpers:HasBuff("player", buffTexture)

    return self
end

function SelfBuffTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.buffUp = Helpers:HasBuff("player", self.buffTexture)
end

--- @param event string
--- @param arg1 string
function SelfBuffTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    self.buffPipeline:ApplySelfBuffEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, function(msg)
        if not msg then
            return
        end
        if msg.kind == BuffPipelineKind.BUFF_UP then
            Logging:Debug(self.abilityName .. " is up")
            self.buffUp = true
        else
            Logging:Debug(self.abilityName .. (msg.via_chat and " is down (chat)" or " is down"))
            self.buffUp = false
        end
    end)
end

--- @return boolean
function SelfBuffTracker:ShouldCast()
    return not self.buffUp
end