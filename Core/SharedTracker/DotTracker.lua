--- @class DotTracker : CooldownTracker
--- @field rankedAbility Ability
--- @field data table<string, table>
--- @field buffApi BuffApi
DotTracker = setmetatable({}, { __index = CooldownTracker })
DotTracker.__index = DotTracker

--- @param rankedAbility Ability
--- @return DotTracker
function DotTracker.new(rankedAbility)
    --- @class DotTracker
    local self = CooldownTracker.new()
    setmetatable(self, DotTracker)

    local buffApi = BuffApiFactory.GetInstance()
    self.rankedAbility = rankedAbility
    self.data    = {}
    self.buffApi = buffApi

    return self
end

function DotTracker:subscribe()
    self.data = {}
    CooldownTracker.subscribe(self)
end

--- @param event string
function DotTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    self.buffApi:OnDotTrackerEvent(self, GetTime(), event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function DotTracker:ApplyDot(now, mob, durationSec)
    if not mob then return end

    local dotData    = self:GetMobData(mob)
    dotData.start    = now
    dotData.duration = durationSec
    Logging:Debug(self.rankedAbility.name.." Applied, duration: "..tostring(durationSec))
end

--- @param msg string
function DotTracker:HandleResist(msg)
    if not Helpers:IsSpellApplicationFailureMessage(self.rankedAbility.name, msg) then
        return
    end
    local target = Helpers:GetUnitGUID("target")
    if target then
        self.data[target] = nil
    end
    Logging:Debug(self.rankedAbility.name .. " apply failed (resist/dodge/parry/miss/immune/block)")
end

--- @return boolean
function DotTracker:ShouldCast()
    local remaining = self:GetRemainingOnTarget()
    if not remaining then return true end
    return remaining <= 0 and Helpers:SpellReady(self.rankedAbility.name)
end

--- @return number
function DotTracker:GetRemainingDuration()
    return self:GetRemainingOnTarget() or 0
end

--- @return number
function DotTracker:GetRemainingOnTarget()
    local mob = Helpers:GetUnitGUID("target")
    if not mob then return 0 end

    local dotData = self.data[mob]
    if not dotData then return 0 end

    local now = GetTime()
    return dotData.duration - (now - dotData.start)
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
