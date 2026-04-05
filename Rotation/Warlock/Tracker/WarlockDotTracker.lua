--- @class WarlockDotTracker : MobDotStateTracker
--- @field rankedAbility Ability
--- @field pendingChannel boolean
--- @field dhCasting boolean
--- @field data table<string, table>
--- @field buffPipeline BuffEventPipeline
WarlockDotTracker = setmetatable({}, { __index = MobDotStateTracker })
WarlockDotTracker.__index = WarlockDotTracker

local HASTE_FACTOR = 0.30

--- @param rankedAbility Ability
--- @return WarlockDotTracker
function WarlockDotTracker.new(rankedAbility)
    --- @class WarlockDotTracker
    local self = CooldownTracker.new()
    setmetatable(self, WarlockDotTracker)

    local buffPipeline = BuffApiFactory.GetInstance()
    self.rankedAbility  = rankedAbility
    self.data           = {}
    self.pendingChannel = false
    self.dhCasting      = false
    self.buffPipeline = buffPipeline

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
    self.buffPipeline:ApplyWarlockDotEvent(self, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, function(msg)
        if not msg then
            return
        end
        if msg.kind == BuffPipelineKind.DH_PENDING_CHANNEL then
            self.pendingChannel = true
        elseif msg.kind == BuffPipelineKind.DH_CHANNEL_START then
            self.dhCasting = true
            self.pendingChannel = false
            self:StartDarkHarvest(target, now)
            Logging:Debug("Dark Harvest channel started (" .. tostring((msg.channelDurationMs or 0) / 1000) .. "s)")
        elseif msg.kind == BuffPipelineKind.DH_CHANNEL_STOP then
            if self.dhCasting then
                self.dhCasting = false
                self.pendingChannel = false
                self:EndDarkHarvest(target, now)
                Logging:Debug("Dark Harvest channel stopped / interrupted")
            end
        elseif msg.kind == BuffPipelineKind.DEBUFF_CLEAR_DATA then
            self.pendingChannel = false
            self.dhCasting = false
            self.data = {}
        else
            self:TryConsumeMobDotPipelineMessage(msg, now)
        end
    end)
end

--- @param dotData table
--- @param now number
--- @param durationSec number
function WarlockDotTracker:ResetDotStateOnApply(dotData, now, durationSec)
    MobDotStateTracker.ResetDotStateOnApply(self, dotData, now, durationSec)
    dotData.dhStartTime = nil
    dotData.dhEndTime   = nil
end

--- @param durationSec number
function WarlockDotTracker:LogDotApplied(durationSec)
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
