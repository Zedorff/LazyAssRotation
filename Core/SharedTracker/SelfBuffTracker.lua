--- @class SelfBuffTracker : CooldownTracker
--- @field abilityName string
--- @field buffTexture string
--- @field buffUp boolean
--- @field buffApi BuffApi
SelfBuffTracker = setmetatable({}, { __index = CooldownTracker })
SelfBuffTracker.__index = SelfBuffTracker

--- @param abilityName string
--- @param buffTexture string
--- @return SelfBuffTracker
function SelfBuffTracker.new(abilityName, buffTexture)
    --- @class SelfBuffTracker
    local self = CooldownTracker.new()
    setmetatable(self, SelfBuffTracker)

    local buffApi = BuffApiFactory.GetInstance()
    self.abilityName = abilityName
    self.buffTexture = buffTexture
    self.buffApi = buffApi
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
    if event == "PLAYER_DEAD" then
        self.buffUp = false
        return
    end
    self.buffApi:OnSelfBuffEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @return boolean
function SelfBuffTracker:ShouldCast()
    return not self.buffUp
end