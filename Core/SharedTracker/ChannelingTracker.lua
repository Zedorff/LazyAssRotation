--- @class ChannelingTracker : CooldownTracker
--- @field isChanneling boolean
--- @diagnostic disable: duplicate-set-field
ChannelingTracker = setmetatable({}, { __index = CooldownTracker })
ChannelingTracker.__index = ChannelingTracker

--- @return ChannelingTracker
function ChannelingTracker.new()
    --- @class ChannelingTracker
    local self = CooldownTracker.new()
    setmetatable(self, ChannelingTracker)
    self.isChanneling = false
    return self
end

function ChannelingTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.isChanneling = false
end

--- @param event string
--- @param arg1 string
function ChannelingTracker:onEvent(event, arg1)
    if event == "SPELLCAST_CHANNEL_START" then
        Logging:Debug("Channeling spell is casting")
        self.isChanneling = true
    elseif event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_INTERRUPTED" then
        Logging:Debug("Channeling spell stopped casting")
        self.isChanneling = false
    end 
end

--- @return boolean
function ChannelingTracker:ShouldCast()
    return not self.isChanneling
end
