--- @class WarlockDotTracker : CooldownTracker
--- @field rankedAbility Ability
--- @field pendingChannel boolean
--- @field dhCasting boolean
--- @field data table<string, table>
--- @field buffApi BuffApi
WarlockDotTracker = setmetatable({}, { __index = CooldownTracker })
WarlockDotTracker.__index = WarlockDotTracker

local HASTE_FACTOR = 0.30

--- @param rankedAbility Ability
--- @return WarlockDotTracker
function WarlockDotTracker.new(rankedAbility)
    --- @class WarlockDotTracker
    local self = CooldownTracker.new()
    setmetatable(self, WarlockDotTracker)

    local buffApi = BuffApiFactory.GetInstance()
    self.rankedAbility  = rankedAbility
    self.data           = {}
    self.pendingChannel = false
    self.dhCasting      = false
    self.buffApi = buffApi

    return self
end

function WarlockDotTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.data           = {}
    self.pendingChannel = false
    self.dhCasting      = false
end

function WarlockDotTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    local now = GetTime()
    local target = Helpers:GetUnitGUID("target")
    self.buffApi:OnWarlockDotTrackerEvent(self, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function WarlockDotTracker:ApplyDot(now, mob, durationSec)
    if not mob then return end

    local dotData       = self:GetMobData(mob)
    dotData.start       = now
    dotData.duration    = durationSec
    dotData.dhStartTime = nil
    dotData.dhEndTime   = nil
    Logging:Debug("Apply dot: " .. self.rankedAbility.name .. ", withDuration: " .. tostring(durationSec))
end

--- @param mob string | nil
--- @param now number
function WarlockDotTracker:StartDarkHarvest(mob, now)
    if not mob then return end

    local dotData = self.data[mob]
    if not dotData then return end

    if not dotData.dhStartTime then
        dotData.dhStartTime = now
        dotData.dhEndTime   = nil
    end
    Logging:Debug("Dark Harvest started for: " .. self.rankedAbility.name)
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
    Logging:Debug("Dark Harvest stopped for: " .. self.rankedAbility.name)
end

--- @param msg string
function WarlockDotTracker:HandleResist(msg)
    if msg and string.find(msg, self.rankedAbility.name) and (string.find(msg, "resisted") or string.find(msg, "immune") or string.find(msg, "dodged") or string.find(msg, "parried") or string.find(msg, "missed")) or string.find(msg, "blocked") then
        local target = Helpers:GetUnitGUID("target")
        self.data[target] = nil
        Logging:Debug(self.rankedAbility.name .. " was miss/dodge/parry/miss/resist/blocked")
    end
end

--- @return boolean
function WarlockDotTracker:ShouldCast()
    local remaining = self:GetRemainingOnTarget()
    if not remaining then return true end
    return remaining <= 0 and Helpers:SpellReady(self.rankedAbility.name)
end

--- @return number
function WarlockDotTracker:GetRemainingDuration()
    return self:GetRemainingOnTarget() or 0
end

--- @return number | nil
function WarlockDotTracker:GetRemainingOnTarget()
    local mob = Helpers:GetUnitGUID("target")
    if not mob then return nil end

    local dotData = self.data[mob]
    if not dotData then return 0 end

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
