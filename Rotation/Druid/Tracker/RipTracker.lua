--- @class RipTracker : CooldownTracker
--- @field ripActiveUntil number
--- @field currentTargetName string | nil
--- @field pendingRipTarget string | nil
--- @field pendingRipApplyTime number | nil
RipTracker = setmetatable({}, { __index = CooldownTracker })
RipTracker.__index = RipTracker

local RIP_DURATION = 12

local haveSavageryIdol = false
local haveRavagerCloak = false

--- @return RipTracker
function RipTracker.new()
    --- @class RipTracker
    local self = CooldownTracker.new()
    setmetatable(self, RipTracker)
    self.ripActiveUntil = 0
    self.currentTargetName = nil
    self.pendingRipTarget = nil
    self.pendingRipApplyTime = nil
    self:CheckGear()
    return self
end

--- @param event string
--- @param arg1 string
function RipTracker:onEvent(event, arg1)
    local now = GetTime()

    if event == "PLAYER_TARGET_CHANGED" then
        self:ResetTracking()

    elseif event == "LAR_SPELL_CAST" and arg1 == "Rip" then
        self:StartPendingRip()

    elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
        self:CheckRipTick(arg1, now)

    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
        self:HandleSelfDamage(arg1, now)
    elseif event == "UNIT_INVENTORY_CHANGED" then
        self:CheckGear()
    end
end

function RipTracker:subscribe()
    Core:SubscribeToHookedEvents()
    CooldownTracker.subscribe(self)
    self:CheckGear()
end

function RipTracker:unsubscribe()
    Core:UnsubscribeFromHookedEvents()
    CooldownTracker.unsubscribe(self)
end

function RipTracker:ResetTracking()
    self.currentTargetName = UnitName("target") or nil
    self.ripActiveUntil = 0
    self.pendingRipTarget = nil
    self.pendingRipApplyTime = nil
    Logging:Debug("Target changed or lost. Reset rip tracking.")
end

function RipTracker:StartPendingRip()
    self.pendingRipTarget = UnitName("target") or nil
    self.pendingRipApplyTime = GetTime()
    Logging:Debug("Rip cast initiated on " .. (self.pendingRipTarget or "unknown target"))
end

--- @param arg1 string
--- @param now number
function RipTracker:CheckRipTick(arg1, now)
    if arg1 and string.find(arg1, "from your Rip") then
        if self.pendingRipTarget and self.pendingRipApplyTime then
            local delay = now - self.pendingRipApplyTime
            if delay <= 5 then
                local remaining = (self:CalculateRipDuration() + 0.5) - delay
                self.ripActiveUntil = now + remaining
                Logging:Debug(string.format("Rip confirmed by tick. Delay: %.1fs, Set duration to %.1fs", delay, remaining))
            end
            self.pendingRipTarget = nil
            self.pendingRipApplyTime = nil
        end
    end
end

--- @param arg1 string
--- @param now number
function RipTracker:HandleSelfDamage(arg1, now)
    if arg1 and string.find(arg1, "Your Rip was") and (string.find(arg1,"dodged") or string.find(arg1,"parried")) then
        self.ripActiveUntil = 0
        self.pendingRipTarget = nil
        self.pendingRipApplyTime = nil
        Logging:Debug("Rip failed to apply (dodged or parried).")
    end
end

--- @return boolean
function RipTracker:ShouldCast()
    return GetTime() > self.ripActiveUntil and Helpers:SpellReady(ABILITY_RIP)
end

--- @param msg string
--- @return boolean
function IsCritMessage(msg)
    return string.find(msg, " crit") or string.find(msg, "crits")
end

--- @return number
function RipTracker:GetRipRemainingTime()
    return self.ripActiveUntil - GetTime()
end

function RipTracker:CheckGear()
    haveSavageryIdol = string.find(GetInventoryItemLink("player", 18), "item:61699:")
    haveRavagerCloak = string.find(GetInventoryItemLink("player", 15), "item:55095:")
end

function RipTracker:CalculateRipDuration()
    local tickMultiplier = 1
    if haveRavagerCloak then
        tickMultiplier = tickMultiplier - 0.05
    end
    if haveSavageryIdol then
        tickMultiplier = tickMultiplier - 0.1
    end

    return RIP_DURATION * tickMultiplier
end
