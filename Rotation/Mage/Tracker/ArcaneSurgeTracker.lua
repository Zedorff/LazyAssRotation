--- @class ArcaneSurgeTracker : CooldownTracker
--- @field surgeReadyUntil number
--- @diagnostic disable: duplicate-set-field
ArcaneSurgeTracker = setmetatable({}, { __index = CooldownTracker })
ArcaneSurgeTracker.__index = ArcaneSurgeTracker

--- @return ArcaneSurgeTracker
function ArcaneSurgeTracker.new()
    --- @class ArcaneSurgeTracker
    local self = CooldownTracker.new()
    setmetatable(self, ArcaneSurgeTracker)
    self.surgeReadyUntil = 0
    return self
end

--- @param event string
--- @param arg1 string
function ArcaneSurgeTracker:onEvent(event, arg1)
    if event == "UI_ERROR_MESSAGE" and string.find(arg1, "You can't do that yet") then
        self.surgeReadyUntil = 0;
        Logging:Debug(ABILITY_ARCANE_SURGE .. " is down")
    end
    if event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, "resisted") then
        self.surgeReadyUntil = GetTime() + 4
        Logging:Debug(ABILITY_ARCANE_SURGE .. " is up")
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, ABILITY_ARCANE_SURGE) then
        self.surgeReadyUntil = 0;
        Logging:Debug(ABILITY_ARCANE_SURGE .. " is down")
    end
end

--- @return boolean
function ArcaneSurgeTracker:ShouldCast()
    local now = GetTime()
    local delta = self.surgeReadyUntil - now
    local cd = Helpers:SpellNotReadyFor(ABILITY_ARCANE_SURGE)

    return delta >= cd and cd <= 0.8
end
