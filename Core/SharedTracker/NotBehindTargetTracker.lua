--- @class NotBehindTargetTracker : CooldownTracker
--- @field lastCastAttmept number
--- @diagnostic disable: duplicate-set-field
NotBehindTargetTracker = setmetatable({}, { __index = CooldownTracker })
NotBehindTargetTracker.__index = NotBehindTargetTracker

--- @return NotBehindTargetTracker
function NotBehindTargetTracker.new()
    --- @class NotBehindTargetTracker
    local self = CooldownTracker.new()
    setmetatable(self, NotBehindTargetTracker)
    self.lastCastAttmept = 0
    return self
end

function NotBehindTargetTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.lastCastAttmept = 0
end

--- @param event string
--- @param arg1 string
function NotBehindTargetTracker:onEvent(event, arg1)
    if event == "UI_ERROR_MESSAGE" and string.find(arg1, "You must be behind your target") then
        self.lastCastAttmept = GetTime()
    end
end

--- @return boolean
function NotBehindTargetTracker:ShouldCast()
    return false
end

function NotBehindTargetTracker:GetLastAttemptTime()
    return GetTime() - self.lastCastAttmept
end
