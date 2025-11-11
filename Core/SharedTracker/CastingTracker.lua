--- @class CastingTracker : CooldownTracker
--- @field castingUntil number
--- @field channelingUntil number
--- @diagnostic disable: duplicate-set-field
CastingTracker = setmetatable({}, { __index = CooldownTracker })
CastingTracker.__index = CastingTracker
--- @type CastingTracker | nil
local sharedInstance = nil

--- @return CastingTracker
function CastingTracker.GetInstance()
    if sharedInstance then
        return sharedInstance
    end

    --- @class CastingTracker
    local self = CooldownTracker.new()
    setmetatable(self, CastingTracker)
    self.castingUntil = 0
    self.channelingUntil = 0

    sharedInstance = self

    return sharedInstance
end

function CastingTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.castingUntil = 0
    self.channelingUntil = 0
end

--- @param event string
--- @param arg1 string
function CastingTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5)
    if event == "PLAYER_DEAD" then
        self.castingUntil = 0
    elseif event == "UNIT_CASTEVENT" and arg1 == ({ UnitExists("player") })[2] then
        if arg3 == "START" then
            self.castingUntil = GetTime() + arg5
        elseif arg3 == "CAST" or arg3 == "FAIL" then
            self.castingUntil = 0
        end
    elseif event == "SPELLCAST_CHANNEL_START" and arg1 then
        Logging:Debug("Channeling spell is casting")
        self.channelingUntil = GetTime() + arg1 / 1000
    elseif event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_INTERRUPTED" then
        Logging:Debug("Channeling spell stopped casting")
        self.channelingUntil = 0
    end 
end

--- @return boolean
function CastingTracker:ShouldCast()
    return self.castingUntil < GetTime() and self.channelingUntil < GetTime()
end

--- @return boolean
function CastingTracker:IsChanneling()
    return self.channelingUntil > GetTime()
end
