--- @class SelfBuffTracker : CooldownTracker
--- @field abilityName string
--- @field buffTexture string
--- @field buffUp boolean
SelfBuffTracker = setmetatable({}, { __index = CooldownTracker })
SelfBuffTracker.__index = SelfBuffTracker

--- @param abilityName string
--- @param buffTexture string
--- @return SelfBuffTracker
function SelfBuffTracker.new(abilityName, buffTexture)
    --- @class SelfBuffTracker
    local self = CooldownTracker.new()
    setmetatable(self, SelfBuffTracker)

    self.abilityName = abilityName
    self.buffTexture = buffTexture
    self.buffUp = Helpers:HasBuff("player", buffTexture)

    return self
end

function SelfBuffTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.buffUp = Helpers:HasBuff("player", self.buffTexture)
end

--- @param event string
--- @param arg1 string
function SelfBuffTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.buffUp = false
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, self.abilityName) then
        Logging:Debug(self.abilityName .. " is up")
        self.buffUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, self.abilityName) then
        Logging:Debug(self.abilityName .. " is down")
        self.buffUp = false
    end
end

--- @return boolean
function SelfBuffTracker:ShouldCast()
    return not self.buffUp
end