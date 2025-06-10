--- @class DotTracker : CooldownTracker
--- @field ability string
--- @field lastCastTime number | nil
--- @field data table<string, table>
DotTracker = setmetatable({}, { __index = CooldownTracker })
DotTracker.__index = DotTracker

--- @param ability string
--- @return DotTracker
function DotTracker.new(ability)
    --- @class DotTracker
    local self = CooldownTracker.new()
    setmetatable(self, DotTracker)

    self.ability      = ability
    self.data         = {}
    self.lastCastTime = nil

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
    local target = UnitName("target")

    if event == "LAR_SPELL_CAST" and arg1 == self.ability then
        self:ApplyDot(now, target)
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        self:HandleResist(arg1)
    elseif event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" then
        self:HandleDeath(arg1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        self.data = {}
    elseif event == "UI_ERROR_MESSAGE" then
        self:HandleCastError(arg1)
    end
end

--- @param now number
--- @param mob string | nil
function DotTracker:ApplyDot(now, mob)
    if not mob then return end

    local duration    = Helpers:SpellDuration(self.ability)
    self.lastCastTime = now

    local dotData     = self:GetMobData(mob)
    dotData.start     = now
    dotData.duration  = duration
end

--- @param msg string
function DotTracker:HandleResist(msg)
    if msg and string.find(msg, self.ability) and (string.find(msg, "resist") or string.find(msg, "immune") or string.find(msg, "dodge") or string.find(msg, "parry") or string.find(msg, "miss")) then
        self.data[UnitName("target")] = nil
    end
end

--- @param msg string
function DotTracker:HandleDeath(msg)
    local mob = msg and (string.match(msg, "^(.-) dies") or string.match(msg, "^You have slain (.-)!"))
    if mob then
        self.data[mob] = nil
    end
end

--- @param message string
function DotTracker:HandleCastError(message)
    if not self.lastCastTime then return end
    if type(message) ~= "string" or message == "" then return end

    local now = GetTime()
    if now - self.lastCastTime > 2 then
        self.lastCastTime = nil
        return
    end

    local msgLower = string.lower(message)
    if string.find(msgLower, "not ready") or string.find(msgLower, "out of range") or
        string.find(msgLower, "interrupted") or string.find(msgLower, "moving") or
        string.find(msgLower, "stunned") or string.find(msgLower, "mounted") or
        string.find(msgLower, "standing") then
        local target = UnitName("target")
        if target then
            self.data[target] = nil
        end

        self.lastCastTime = nil
    end
end

--- @return boolean
function DotTracker:ShouldCast()
    local mob = UnitName("target")
    if not mob then return false end

    local dotData = self.data[mob]
    if not dotData then return true end

    local now = GetTime()
    local remaining = dotData.duration - (now - dotData.start)
    return remaining <= 0 and Helpers:SpellReady(self.ability)
end

--- @param mob string
--- @return table
function DotTracker:GetMobData(mob)
    local dotData = self.data[mob]
    if not dotData then
        dotData = {}
        self.data[mob] = dotData
    end
    return dotData
end
