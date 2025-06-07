--- @class ChannelingTracker : CooldownTracker
--- @field channelingUntill number
--- @diagnostic disable: duplicate-set-field
ChannelingTracker = setmetatable({}, { __index = CooldownTracker })
ChannelingTracker.__index = ChannelingTracker

--- @return ChannelingTracker
function ChannelingTracker.new()
    --- @class ChannelingTracker
    local self = CooldownTracker.new()
    setmetatable(self, ChannelingTracker)
    self.channelingUntill = 0
    return self
end

function ChannelingTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.channelingUntill = 0
end

--- @param event string
--- @param arg1 string
function ChannelingTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.channelingUntill = 0
    elseif event == "SPELLCAST_CHANNEL_START" and arg1 then
        Logging:Debug("Channeling spell is casting")
        self.channelingUntill = GetTime() + arg1 / 1000
    elseif event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_INTERRUPTED" then
        Logging:Debug("Channeling spell stopped casting")
        self.channelingUntill = 0
    end 
end

--- @return boolean
function ChannelingTracker:ShouldCast()
    return self.channelingUntill < GetTime()
end
