--- @class DotTracker : CooldownTracker
--- @field ability string
--- @field duration number
--- @field activeByName table<string, number>
--- @field pendingByName table<string, number>
--- @field lastPendingTarget string
--- @field lastPendingTime number
DotTracker = setmetatable({}, { __index = CooldownTracker })
DotTracker.__index = DotTracker

--- @param ability string
--- @param duration number
--- @return DotTracker
function DotTracker.new(ability, duration)
    --- @class DotTracker
    local self = CooldownTracker.new()
    setmetatable(self, DotTracker)
    self.ability = ability
    self.duration = duration
    self.activeByName = {}
    self.pendingByName = {}
    return self
end

function DotTracker:subscribe()
    Core:SubscribeToHookedEvents()
    CooldownTracker.subscribe(self)
end

function DotTracker:unsubscribe()
    Core:UnsubscribeFromHookedEvents()
    CooldownTracker.unsubscribe(self)
end

--- @param event string
--- @param arg1 string
function DotTracker:onEvent(event, arg1)
    local now = GetTime()
    if event == "LAR_SPELL_CAST" and arg1 == self.ability then
        self:StartPending(UnitName("target") or "")
    elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
        self:HandleTick(arg1, now)
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        self:HandleResist(arg1)
    elseif event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" then
        self:HandleDeath(arg1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        self.activeByName = {}
        self.pendingByName = {}
    elseif event == "UI_ERROR_MESSAGE" then
        self:HandleCastError(arg1)
    end
end

function DotTracker:StartPending(target)
    self.pendingByName[target] = GetTime()
    self.lastPendingTarget = target
    self.lastPendingTime = GetTime()
end

--- @param msg string
--- @param now number
function DotTracker:HandleTick(msg, now)
    local mob = string.match(msg, "^(.-) suffers %d+ .- from your " .. self.ability)
    if mob then
        local castTime = self.pendingByName[mob]
        if castTime then
            local delay = now - castTime
            if delay <= 7 then
                self.activeByName[mob] = now + (self.duration - delay)
            end
            self.pendingByName[mob] = nil
        end
    end
end

--- @param msg string
function DotTracker:HandleResist(msg)
    if msg and string.find(msg, self.ability) and (string.find(msg, "resist") or string.find(msg, "immune") or string.find(msg, "dodge") or string.find(msg, "parry") or string.find(msg, "miss")) then
        local mob = UnitName("target")
        if mob then
            self.activeByName[mob] = nil
            self.pendingByName[mob] = nil
        end
    end
end

--- @param msg string
function DotTracker:HandleDeath(msg)
    if not msg then return end

    local mob =
        string.match(msg, "^(.-) dies") or
        string.match(msg, "^You have slain (.-)!")

    if mob then
        self.activeByName[mob]  = nil
        self.pendingByName[mob] = nil
        Logging:Debug("Removing " .. mob .. " from DoT tables (dead).")
    end
end

function DotTracker:HandleCastError(message)
    if not self.lastPendingTarget then return end
    local now = GetTime()

    -- Only consider error messages that come within ~2 seconds after pending start
    if now - self.lastPendingTime > 2 then
        self.lastPendingTarget = nil
        return
    end

    -- Check if msg is in known failure messages (partial matching)
    if string.find(string.lower(message), "not ready") or string.find(string.lower(message), "out of range") or 
       string.find(string.lower(message), "interrupted") or string.find(string.lower(message), "moving") or
       string.find(string.lower(message), "stunned") or string.find(string.lower(message), "mounted") then
       
        self.pendingByName[self.lastPendingTarget] = nil
        Logging:Debug("DotTracker: Cleared pending cast for " .. self.lastPendingTarget .. " due to cast failure: " .. message)
        self.lastPendingTarget = nil
    end
end

--- @return boolean
function DotTracker:ShouldCast()
    local mob = UnitName("target")
    if not mob then return false end
    local now = GetTime()
    local expires = self.activeByName[mob] or 0
    return now > expires and not self.pendingByName[mob] and Helpers:SpellReady(self.ability)
end