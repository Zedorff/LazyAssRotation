--- @class RakeTracker : CooldownTracker
--- @field rakeUpUntill number
--- @diagnostic disable: duplicate-set-field
RakeTracker = setmetatable({}, { __index = CooldownTracker })
RakeTracker.__index = RakeTracker

--- @return RakeTracker
function RakeTracker.new()
    --- @class RakeTracker
    local self = CooldownTracker.new()
    setmetatable(self, RakeTracker)
    self.rakeUpUntill = 0
    return self
end

function RakeTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.rakeUpUntill = 0
end

--- @param event string
--- @param arg1 string
function RakeTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, ABILITY_RAKE) then
        Logging:Debug(ABILITY_RAKE .. " is up")
        self.rakeUpUntill = GetTime() + 9
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.rakeUpUntill = 0
    end
end

--- @return boolean
function RakeTracker:ShouldCast()
    return self.rakeUpUntill < GetTime()
end
