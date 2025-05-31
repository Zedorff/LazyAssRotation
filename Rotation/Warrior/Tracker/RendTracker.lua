--- @class RendTracker : CooldownTracker
--- @field rendActiveUntil number
--- @field currentTargetName string | nil
--- @field pendingRendTarget string | nil
--- @field pendingRendApplyTime number | nil
RendTracker = setmetatable({}, { __index = CooldownTracker })
RendTracker.__index = RendTracker

--- @return RendTracker
function RendTracker.new()
    --- @class RendTracker
    local self = CooldownTracker.new()
    setmetatable(self, RendTracker)
    self.rendActiveUntil = 0
    self.currentTargetName = nil
    self.pendingRendTarget = nil
    self.pendingRendApplyTime = nil
    return self
end

--- @param event string
--- @param arg1 string
function RendTracker:onEvent(event, arg1)
    local now = GetTime()

    if event == "PLAYER_TARGET_CHANGED" then
        self:ResetTracking()

    elseif event == "LAR_SPELL_CAST" and arg1 == "Rend" then
        self:StartPendingRend()

    elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
        self:CheckRendTick(arg1, now)

    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
        self:HandleSelfDamage(arg1, now)
    end
end

function RendTracker:subscribe()
    Core:SubscribeToHookedEvents()
    CooldownTracker.subscribe(self)
end

function RendTracker:unsubscribe()
    Core:UnsubscribeFromHookedEvents()
    CooldownTracker.unsubscribe(self)
end

function RendTracker:ResetTracking()
    self.currentTargetName = UnitName("target") or nil
    self.rendActiveUntil = 0
    self.pendingRendTarget = nil
    self.pendingRendApplyTime = nil
    Logging:Debug("Target changed or lost. Reset rend tracking.")
end

function RendTracker:StartPendingRend()
    self.pendingRendTarget = UnitName("target") or nil
    self.pendingRendApplyTime = GetTime()
    Logging:Debug("Rend cast initiated on " .. (self.pendingRendTarget or "unknown target"))
end

--- @param arg1 string
--- @param now number
function RendTracker:CheckRendTick(arg1, now)
    if arg1 and string.find(arg1, "from your Rend") then
        if self.pendingRendTarget and self.pendingRendApplyTime then
            local delay = now - self.pendingRendApplyTime
            if delay <= 5 then
                local remaining = 21.5 - delay
                self.rendActiveUntil = now + remaining
                Logging:Debug(string.format("Rend confirmed by tick. Delay: %.1fs, Set duration to %.1fs", delay, remaining))
            end
            self.pendingRendTarget = nil
            self.pendingRendApplyTime = nil
        end
    end
end

--- @param arg1 string
--- @param now number
function RendTracker:HandleSelfDamage(arg1, now)
    if arg1 and string.find(arg1, "Your Rend was") and (string.find(arg1,"dodged") or string.find(arg1,"parried")) then
        self.rendActiveUntil = 0
        self.pendingRendTarget = nil
        self.pendingRendApplyTime = nil
        Logging:Debug("Rend failed to apply (dodged or parried).")
    end
end

--- @return boolean
function RendTracker:ShouldCast()
    return GetTime() > self.rendActiveUntil and Helpers:SpellReady(ABILITY_REND)
end

--- @param msg string
--- @return boolean
function IsCritMessage(msg)
    return string.find(msg, " crit") or string.find(msg, "crits")
end
