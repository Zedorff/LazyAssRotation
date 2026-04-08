local NAMPOWER_ECLIPSE_FALLBACK_DURATION_SEC = 15

--- @class NampowerBuffPipeline : BuffPipeline
NampowerBuffPipeline = setmetatable({}, { __index = BuffPipeline })
NampowerBuffPipeline.__index = NampowerBuffPipeline

--- @return NampowerBuffPipeline
function NampowerBuffPipeline.new()
    local self = setmetatable({}, NampowerBuffPipeline)
    ---@cast self NampowerBuffPipeline
    return self
end

local function nampowerSelfAuraMatches(spellId, arg3, buffTexture, abilityName)
    local playerGuid = Helpers:GetUnitGUID("player")
    return spellId and playerGuid and arg3 == playerGuid
        and Helpers:MatchesSelfBuffSpell(spellId, buffTexture, abilityName)
end

--- @param mobGuid string|nil
--- @param spellId number|nil
--- @param arg7 unknown|nil
--- @param ability Ability
--- @param removeNew fun(mobGuid: string): table
--- @return table|nil
local function tryRemoval(mobGuid, spellId, arg7, ability, removeNew)
    if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
        return nil
    end
    if not mobGuid or not spellId or not IsMatchingRank(ability, spellId) then
        return nil
    end
    return removeNew(mobGuid)
end

--- @param tracker DebuffTracker
--- @param arg1 string|nil
--- @param arg2 string|nil
--- @param arg3 string|nil
--- @param _arg4 unknown|nil
--- @param _arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineDebuffApply|nil
function NampowerBuffPipeline:TryDebuffApply(tracker, arg1, arg2, arg3, _arg4, _arg7, arg8)
    local spellId = tonumber(arg1)
    local playerGuid = Helpers:GetUnitGUID("player")
    if not playerGuid or not spellId or not arg3 then
        return nil
    end
    if (not tracker.isSharedDebuff) and (arg2 ~= playerGuid) then
        return nil
    end
    if not IsMatchingRank(tracker.ability, spellId) then
        return nil
    end
    local durationSec = NampowerBuffCommon.DurationSecFromAuraCast(arg8, Helpers:DebuffDuration(tracker.ability.name))
    return PipelineDebuffApply.new(arg3, durationSec)
end

--- @param tracker DotTracker|WarlockDotTracker
--- @param arg1 string|nil
--- @param arg2 string|nil
--- @param arg3 string|nil
--- @param _arg4 unknown|nil
--- @param _arg7 unknown|nil
--- @param arg8 unknown|nil
--- @param applyNew fun(mobGuid: string, durationSec: number): table
--- @return table|nil
local function tryRankedDotAuraCastOnOther(tracker, arg1, arg2, arg3, _arg4, _arg7, arg8, applyNew)
    local spellId = tonumber(arg1)
    local playerGuid = Helpers:GetUnitGUID("player")
    if not playerGuid or not spellId or not arg3 then
        return nil
    end
    if arg2 ~= playerGuid then
        return nil
    end
    if not IsMatchingRank(tracker.rankedAbility, spellId) then
        return nil
    end
    local durationSec = NampowerBuffCommon.DurationSecFromAuraCast(arg8, Helpers:SpellDuration(tracker.rankedAbility.name))
    return applyNew(arg3, durationSec)
end

--- @param tracker DotTracker
--- @param arg1 string|nil
--- @param arg2 string|nil
--- @param arg3 string|nil
--- @param arg4 unknown|nil
--- @param arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineDotApply|nil
function NampowerBuffPipeline:TryDotApply(tracker, arg1, arg2, arg3, arg4, arg7, arg8)
    return tryRankedDotAuraCastOnOther(tracker, arg1, arg2, arg3, arg4, arg7, arg8, PipelineDotApply.new)
end

--- @param tracker WarlockDotTracker
--- @param arg1 string|nil
--- @param arg2 string|nil
--- @param arg3 string|nil
--- @param arg4 unknown|nil
--- @param arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineWarlockDotApply|nil
function NampowerBuffPipeline:TryWarlockDotApply(tracker, arg1, arg2, arg3, arg4, arg7, arg8)
    return tryRankedDotAuraCastOnOther(tracker, arg1, arg2, arg3, arg4, arg7, arg8, PipelineWarlockDotApply.new)
end

--- @param mobGuid string|nil
--- @param spellId number|nil
--- @param arg7 unknown|nil
--- @param tracker DebuffTracker
--- @return PipelineDebuffRemove|nil
function NampowerBuffPipeline:TryDebuffRemove(mobGuid, spellId, arg7, tracker)
    return tryRemoval(mobGuid, spellId, arg7, tracker.ability, PipelineDebuffRemove.new)
end

--- @param mobGuid string|nil
--- @param spellId number|nil
--- @param arg7 unknown|nil
--- @param tracker DotTracker
--- @return PipelineDotRemove|nil
function NampowerBuffPipeline:TryDotRemove(mobGuid, spellId, arg7, tracker)
    return tryRemoval(mobGuid, spellId, arg7, tracker.rankedAbility, PipelineDotRemove.new)
end

--- @param mobGuid string|nil
--- @param spellId number|nil
--- @param arg7 unknown|nil
--- @param tracker WarlockDotTracker
--- @return PipelineWarlockDotRemove|nil
function NampowerBuffPipeline:TryWarlockDotRemove(mobGuid, spellId, arg7, tracker)
    return tryRemoval(mobGuid, spellId, arg7, tracker.rankedAbility, PipelineWarlockDotRemove.new)
end

--- @param tracker SelfBuffTracker
--- @param event string
--- @param arg1 unknown|nil
--- @param arg3 string|nil
--- @param arg7 unknown|nil
--- @param _arg8 unknown|nil
--- @return PipelineSelfBuffUp|PipelineSelfBuffDown|nil
function NampowerBuffPipeline:TrySelfBuffMessage(tracker, event, arg1, arg3, arg7, _arg8)
    if event == "AURA_CAST_ON_SELF" then
        local spellId = tonumber(arg1)
        if nampowerSelfAuraMatches(spellId, arg3, tracker.buffTexture, tracker.abilityName) then
            return PipelineSelfBuffUp.new()
        end
    elseif event == "BUFF_REMOVED_SELF" then
        if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
            return nil
        end
        local spellId = tonumber(arg3)
        if spellId and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            return PipelineSelfBuffDown.new()
        end
    end
    return nil
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
--- @param arg1 unknown|nil
--- @param arg3 string|nil
--- @param arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineDurationedSelfBuffUp|PipelineDurationedSelfBuffDown|nil
function NampowerBuffPipeline:TryDurationedSelfBuffMessage(tracker, event, arg1, arg3, arg7, arg8)
    if event == "AURA_CAST_ON_SELF" then
        local spellId = tonumber(arg1)
        if nampowerSelfAuraMatches(spellId, arg3, tracker.buffTexture, tracker.abilityName) then
            return PipelineDurationedSelfBuffUp.new(NampowerBuffCommon.DurationSecFromAuraCast(arg8, tracker.duration))
        end
    elseif event == "BUFF_REMOVED_SELF" then
        if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
            return nil
        end
        local spellId = tonumber(arg3)
        if spellId and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            return PipelineDurationedSelfBuffDown.new()
        end
    end
    return nil
end

--- @param tracker EclipseTracker
--- @param event string
--- @param arg1 unknown|nil
--- @param arg3 string|nil
--- @param arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineEclipseArcane|PipelineEclipseNature|PipelineEclipseClear|nil
function NampowerBuffPipeline:TryEclipseMessage(tracker, event, arg1, arg3, arg7, arg8)
    if event == "AURA_CAST_ON_SELF" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if not (spellId and playerGuid and arg3 == playerGuid) then
            return nil
        end
        local durSec = NampowerBuffCommon.DurationSecFromAuraCast(arg8, NAMPOWER_ECLIPSE_FALLBACK_DURATION_SEC)
        if Helpers:MatchesSelfBuffSpell(spellId, tracker.arcaneBuffTexture, "Arcane Eclipse") then
            return PipelineEclipseArcane.new(durSec)
        elseif Helpers:MatchesSelfBuffSpell(spellId, tracker.natureBuffTexture, "Nature Eclipse") then
            return PipelineEclipseNature.new(durSec)
        end
    elseif event == "BUFF_REMOVED_SELF" then
        if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
            return nil
        end
        local spellId = tonumber(arg3)
        if spellId and (
            Helpers:MatchesSelfBuffSpell(spellId, tracker.arcaneBuffTexture, "Arcane Eclipse")
            or Helpers:MatchesSelfBuffSpell(spellId, tracker.natureBuffTexture, "Nature Eclipse")
        ) then
            return PipelineEclipseClear.new()
        end
    end
    return nil
end
