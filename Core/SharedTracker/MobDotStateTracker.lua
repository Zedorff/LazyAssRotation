--- @class MobDotStateTracker : CooldownTracker
--- @field rankedAbility Ability
--- @field data table<string, table>
MobDotStateTracker = setmetatable({}, { __index = CooldownTracker })
MobDotStateTracker.__index = MobDotStateTracker

--- @param msg table|nil
--- @param now number
--- @return boolean
function MobDotStateTracker:TryConsumeMobDotPipelineMessage(msg, now)
    if not msg then
        return false
    end
    if msg.kind == BuffPipelineKind.DEBUFF_APPLY then
        self:ApplyDot(now, msg.mobGuid, msg.durationSec)
        return true
    elseif msg.kind == BuffPipelineKind.DEBUFF_REMOVE then
        self.data[msg.mobGuid] = nil
        Logging:Debug(self.rankedAbility.name .. " faded on " .. tostring(msg.mobGuid))
        return true
    elseif msg.kind == BuffPipelineKind.DEBUFF_RESIST_LINE then
        self:HandleResist(msg.line)
        return true
    elseif msg.kind == BuffPipelineKind.DEBUFF_SPELL_MISS then
        self:HandleSpellMiss(msg.casterGuid, msg.targetGuid, msg.spellId, msg.missInfo)
        return true
    elseif msg.kind == BuffPipelineKind.DEBUFF_CLEAR_DATA then
        self.data = {}
        return true
    end
    return false
end

function MobDotStateTracker:ApplyDot(now, mob, durationSec)
    if not mob then return end

    local dotData = self:GetMobData(mob)
    self:ResetDotStateOnApply(dotData, now, durationSec)
    self:LogDotApplied(durationSec)
end

--- @param dotData table
--- @param now number
--- @param durationSec number
function MobDotStateTracker:ResetDotStateOnApply(dotData, now, durationSec)
    dotData.start = now
    dotData.duration = durationSec
end

--- @param durationSec number
function MobDotStateTracker:LogDotApplied(durationSec)
    Logging:Debug(self.rankedAbility.name .. " Applied, duration: " .. tostring(durationSec))
end

--- @param msg string
function MobDotStateTracker:HandleResist(msg)
    if not Helpers:IsSpellApplicationFailureMessage(self.rankedAbility.name, msg) then
        return
    end
    local target = Helpers:GetUnitGUID("target")
    if target then
        self.data[target] = nil
    end
    Logging:Debug(self.rankedAbility.name .. " apply failed (resist/dodge/parry/miss/immune/block)")
end

function MobDotStateTracker:HandleSpellMiss(casterGuid, targetGuid, spellId, missInfo)
    local playerGuid = Helpers:GetUnitGUID("player")
    if not playerGuid or casterGuid ~= playerGuid or not targetGuid then
        return
    end
    if not Helpers:IsSpellApplicationMissInfo(missInfo) then
        return
    end
    if not IsMatchingRank(self.rankedAbility, tonumber(spellId)) then
        return
    end
    self.data[targetGuid] = nil
    Logging:Debug(self.rankedAbility.name .. " apply failed (spell miss event)")
end

--- @param mob string
--- @return table
function MobDotStateTracker:GetMobData(mob)
    local dotData = self.data[mob]
    if not dotData then
        dotData = {}
        self.data[mob] = dotData
    end
    return dotData
end

--- @return number
function MobDotStateTracker:GetRemainingOnTarget()
    local mob = Helpers:GetUnitGUID("target")
    if not mob then return 0 end

    local dotData = self.data[mob]
    if not dotData then return 0 end

    local now = GetTime()
    return dotData.duration - (now - dotData.start)
end

--- @return boolean
function MobDotStateTracker:ShouldCast()
    local remaining = self:GetRemainingOnTarget()
    if not remaining then return true end
    return remaining <= 0 and Helpers:SpellReady(self.rankedAbility.name)
end

--- @return number
function MobDotStateTracker:GetRemainingDuration()
    return self:GetRemainingOnTarget() or 0
end
