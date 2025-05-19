MLDps = MLDps or {}

--- Tracks Rend uptime.
--- @class RendTracker : CooldownTracker
--- @field rendActiveUntil number
--- @field currentTargetName string | nil
--- @field pendingRendTarget string | nil
--- @field pendingRendApplyTime number | nil
RendTracker = setmetatable({}, { __index = CooldownTracker })
RendTracker.__index = RendTracker

--- Constructs a new RendTracker and starts spell hook.
--- @return RendTracker
function RendTracker:new()
    local obj = {
        rendActiveUntil = 0,
        currentTargetName = nil,
        pendingRendTarget = nil,
        pendingRendApplyTime = nil,
    }
    MLDps:StartHookingSpellCasts()
    return setmetatable(obj, self)
end

--- Handles all subscribed events.
--- @param event string
--- @vararg any
function RendTracker:onEvent(event, ...)
    local arg1 = unpack(arg)
    local now = GetTime()

    if event == "PLAYER_TARGET_CHANGED" then
        self:ResetTracking()

    elseif event == "MLDPS_SPELL_CAST" and arg1 == "Rend" then
        self:StartPendingRend()

    elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
        self:CheckRendTick(arg1, now)

    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
        self:HandleSelfDamage(arg1, now)

    elseif event == "CHAT_MSG_COMBAT_SELF_HITS" then
        self:HandleMeleeCrit(arg1, now)
    end
end

--- Resets all Rend tracking information when the target changes.
function RendTracker:ResetTracking()
    self.currentTargetName = UnitName("target") or nil
    self.rendActiveUntil = 0
    self.pendingRendTarget = nil
    self.pendingRendApplyTime = nil
    Logging:Debug("Target changed or lost. Reset rend tracking.")
end

--- Starts tracking pending Rend application after cast.
function RendTracker:StartPendingRend()
    self.pendingRendTarget = UnitName("target") or nil
    self.pendingRendApplyTime = GetTime()
    Logging:Debug("Rend cast initiated on " .. (self.pendingRendTarget or "unknown target"))
end

--- Confirms Rend applied successfully via first tick message.
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

--- Handles spell failure (dodge/parry)
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

--- Whether Rend is currently available for cast.
--- @return boolean
function RendTracker:isAvailable()
    return GetTime() > self.rendActiveUntil and Helpers:SpellReady(ABILITY_REND)
end

--- When Rend will be available again (either now or after current duration).
--- @return number
function RendTracker:GetWhenAvailable()
    return self.rendActiveUntil
end

--- Utility to check if a message indicates a crit.
--- @param msg string
--- @return boolean
function IsCritMessage(msg)
    return string.find(msg, " crit") or string.find(msg, "crits")
end
