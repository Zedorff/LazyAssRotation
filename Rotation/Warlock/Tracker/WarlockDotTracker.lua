--- @class WarlockDotTracker : CooldownTracker
--- @field castFind string
--- @field ability string
--- @field lastCastTime number | nil
--- @field data table<string, table>
WarlockDotTracker = setmetatable({}, { __index = CooldownTracker })
WarlockDotTracker.__index = WarlockDotTracker

local HASTE_FACTOR = 0.30

--- @param ability string
--- @return WarlockDotTracker
function WarlockDotTracker.new(castFind, ability)
    --- @class WarlockDotTracker
    local self = CooldownTracker.new()
    setmetatable(self, WarlockDotTracker)

    self.castFind     = castFind
    self.ability      = ability
    self.data         = {}
    self.lastCastTime = nil

    return self
end

function WarlockDotTracker:subscribe()
    Core:SubscribeToHookedEvents()
    CooldownTracker.subscribe(self)
end

function WarlockDotTracker:unsubscribe()
    Core:UnsubscribeFromHookedEvents()
    CooldownTracker.unsubscribe(self)
end

--- @param event string
--- @param arg1 string
function WarlockDotTracker:onEvent(event, arg1)
    local now = GetTime()
    local target = UnitName("target")

    if event == "LAR_SPELL_CAST" and string.find(self.castFind, arg1) then
        self:ApplyDot(now, target)
    elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
        self:RecordTick(arg1, now)
    elseif event == "LAR_DH_CHANNEL_START" then
        self:StartDarkHarvest(target, now)
    elseif event == "LAR_DH_CHANNEL_STOP" then
        self:EndDarkHarvest(target, now)
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
function WarlockDotTracker:ApplyDot(now, mob)
    if not mob then return end

    local duration      = Helpers:SpellDuration(self.ability)
    self.lastCastTime   = now

    local dotData       = self:GetMobData(mob)
    dotData.start       = now
    dotData.duration    = duration
    dotData.lastTick    = nil
    dotData.dhStartTime = nil
    dotData.dhEndTime   = nil
    Logging:Debug("Apply dot: " .. self.ability .. ", withDuration: " .. duration)
end

--- @param msg string
--- @param now number
function WarlockDotTracker:RecordTick(msg, now)
    if (string.find(msg, "by your "..self.ability)) then
        Logging:Debug("Spell cast confirmed by debuff appliance")
        self.lastCastTime = nil
    end
    local mob = string.match(msg, "^(.-) suffers %d+ .- from your " .. self.ability)
    if not mob then return end

    local dotData = self.data[mob]
    if not dotData then return end

    dotData.lastTick = now
    Logging:Debug("Tick recorded: " .. self.ability .. ", after : " .. (dotData.start - now) .. "s")
end

--- @param mob string | nil
--- @param now number
function WarlockDotTracker:StartDarkHarvest(mob, now)
    if not mob then return end

    local dotData = self.data[mob]
    if not dotData then return end

    if not dotData.dhStartTime then
        dotData.dhStartTime = dotData.lastTick or now
        dotData.dhEndTime   = nil
    end
    Logging:Debug("Dark Harvest started for: " .. self.ability)
end

--- @param mob string | nil
--- @param now number
function WarlockDotTracker:EndDarkHarvest(mob, now)
    if not mob then return end

    local dotData = self.data[mob]
    if not dotData or not dotData.dhStartTime then return end

    if not dotData.dhEndTime then
        dotData.dhEndTime = now
    end
    Logging:Debug("Dark Harvest stopped for: " .. self.ability)
end

--- @param msg string
function WarlockDotTracker:HandleResist(msg)
    if msg and string.find(msg, self.ability) and (string.find(msg, "resist") or string.find(msg, "immune") or string.find(msg, "dodge") or string.find(msg, "parry") or string.find(msg, "miss")) then
        self.data[UnitName("target")] = nil
    end
    Logging:Debug("Spell resist: " .. self.ability)
end

--- @param msg string
function WarlockDotTracker:HandleDeath(msg)
    local mob = msg and (string.match(msg, "^(.-) dies") or string.match(msg, "^You have slain (.-)!"))
    if mob then
        self.data[mob] = nil
    end
end

--- @param message string
function WarlockDotTracker:HandleCastError(message)
    if not self.lastCastTime then return end
    if type(message) ~= "string" or message == "" then return end

    Logging:Log(message)

    local now = GetTime()
    if now - self.lastCastTime > 2 then
        self.lastCastTime = nil
        return
    end

    local msgLower = string.lower(message)
    if string.find(msgLower, "out of range") or string.find(msgLower, "is not ready") or
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
function WarlockDotTracker:ShouldCast()
    local remaining = self:GetRemainingDuration()
    return remaining <= 0 and Helpers:SpellReady(self.ability)
end

--- @return number
function  WarlockDotTracker:GetRemainingDuration()
    local mob = UnitName("target")
    if not mob then return -1 end

    local dotData = self.data[mob]
    if not dotData then return -1 end

    local now = GetTime()
    local dhReduction = 0
    if dotData.dhStartTime then
        local dhEnd = dotData.dhEndTime or now
        local dhActiveDuration = dhEnd - dotData.dhStartTime
        if dhActiveDuration > 0 then
            dhReduction = dhActiveDuration * HASTE_FACTOR
        end
    end

    return dotData.duration - (now - dotData.start) - dhReduction
end

--- @param mob string
--- @return table
function WarlockDotTracker:GetMobData(mob)
    local dotData = self.data[mob]
    if not dotData then
        dotData = {}
        self.data[mob] = dotData
    end
    return dotData
end
