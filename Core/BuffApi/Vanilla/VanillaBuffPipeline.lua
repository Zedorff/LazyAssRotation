local VANILLA_ECLIPSE_DURATION_SEC = 15

--- @class VanillaBuffPipeline : BuffPipeline
VanillaBuffPipeline = setmetatable({}, { __index = BuffPipeline })
VanillaBuffPipeline.__index = VanillaBuffPipeline

--- @return VanillaBuffPipeline
function VanillaBuffPipeline.new()
    local self = setmetatable({}, VanillaBuffPipeline)
    ---@cast self VanillaBuffPipeline
    return self
end

--- @param event string
--- @return boolean
function VanillaBuffPipeline:IsSelfSpellResistEvent(event)
    return event == "CHAT_MSG_SPELL_SELF_DAMAGE"
        or event == "CHAT_MSG_COMBAT_SELF_MISSES"
        or event == "CHAT_MSG_SPELL_SELF_MISSES"
end

--- @param arg1 string|nil
--- @param abilityName string
--- @return string|nil
function VanillaBuffPipeline:TryAuraGoneOtherMobGuid(arg1, abilityName)
    if not arg1 then
        return nil
    end
    if not string.find(arg1, "fades from", 1, true) then
        return nil
    end
    if not string.find(arg1, abilityName, 1, true) then
        return nil
    end
    local targetName = UnitName("target")
    if not targetName or not string.find(arg1, targetName, 1, true) then
        return nil
    end
    return Helpers:GetUnitGUID("target")
end

--- @param tracker DebuffTracker
--- @param arg1 string|nil
--- @param arg2 string|nil
--- @param arg3 string|nil
--- @param arg4 unknown|nil
--- @param _arg7 unknown|nil
--- @param _arg8 unknown|nil
--- @return PipelineDebuffApply|nil
function VanillaBuffPipeline:TryDebuffApply(tracker, arg1, arg2, arg3, arg4, _arg7, _arg8)
    if arg3 ~= "CAST" then
        return nil
    end
    local spellId = tonumber(arg4)
    if not spellId or not IsMatchingRank(tracker.ability, spellId) then
        return nil
    end
    local playerGuid = Helpers:GetUnitGUID("player")
    if (not tracker.isSharedDebuff) and (arg1 ~= playerGuid) then
        return nil
    end
    local mobGuid = arg2 or Helpers:GetUnitGUID("target")
    if not mobGuid then
        return nil
    end
    return PipelineDebuffApply.new(mobGuid, Helpers:DebuffDuration(tracker.ability.name))
end

--- @param tracker DotTracker
--- @param arg1 string|nil
--- @param arg2 string|nil
--- @param arg3 string|nil
--- @param arg4 unknown|nil
--- @param _arg7 unknown|nil
--- @param _arg8 unknown|nil
--- @return PipelineDotApply|nil
function VanillaBuffPipeline:TryDotApply(tracker, arg1, arg2, arg3, arg4, _arg7, _arg8)
    if arg3 ~= "CAST" then
        return nil
    end
    if arg1 ~= Helpers:GetUnitGUID("player") then
        return nil
    end
    if not IsMatchingRank(tracker.rankedAbility, tonumber(arg4)) then
        return nil
    end
    local target = Helpers:GetUnitGUID("target")
    return PipelineDotApply.new(target, Helpers:SpellDuration(tracker.rankedAbility.name))
end

--- @param tracker SelfBuffTracker
--- @param event string
--- @param arg1 string|nil
--- @param _arg3 string|nil
--- @param _arg7 unknown|nil
--- @param _arg8 unknown|nil
--- @return PipelineSelfBuffUp|PipelineSelfBuffDown|nil
function VanillaBuffPipeline:TrySelfBuffMessage(tracker, event, arg1, _arg3, _arg7, _arg8)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and arg1 and string.find(arg1, tracker.abilityName) then
        return PipelineSelfBuffUp.new()
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, tracker.abilityName) then
        return PipelineSelfBuffDown.new()
    end
    return nil
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
--- @param arg1 string|nil
--- @param _arg3 string|nil
--- @param _arg7 unknown|nil
--- @param _arg8 unknown|nil
--- @return PipelineDurationedSelfBuffUp|PipelineDurationedSelfBuffDown|nil
function VanillaBuffPipeline:TryDurationedSelfBuffMessage(tracker, event, arg1, _arg3, _arg7, _arg8)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and arg1 and string.find(arg1, tracker.abilityName) then
        return PipelineDurationedSelfBuffUp.new(tracker.duration)
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, tracker.abilityName) then
        return PipelineDurationedSelfBuffDown.new()
    end
    return nil
end

--- @param _tracker EclipseTracker
--- @param event string
--- @param arg1 string|nil
--- @param _arg3 string|nil
--- @param _arg7 unknown|nil
--- @param _arg8 unknown|nil
--- @return PipelineEclipseArcane|PipelineEclipseNature|PipelineEclipseClear|nil
function VanillaBuffPipeline:TryEclipseMessage(_tracker, event, arg1, _arg3, _arg7, _arg8)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
        if arg1 and string.find(arg1, "Arcane Eclipse") then
            return PipelineEclipseArcane.new(VANILLA_ECLIPSE_DURATION_SEC)
        elseif arg1 and string.find(arg1, "Nature Eclipse") then
            return PipelineEclipseNature.new(VANILLA_ECLIPSE_DURATION_SEC)
        end
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, "Eclipse") then
        return PipelineEclipseClear.new()
    end
    return nil
end
