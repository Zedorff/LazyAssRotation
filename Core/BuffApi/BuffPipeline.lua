--- @class BuffPipeline
BuffPipeline = {}
BuffPipeline.__index = BuffPipeline

--- @return BuffPipeline
function BuffPipeline.new()
    error("BuffPipeline.new() is abstract")
end

--- @param tracker DebuffTracker
--- @param arg1 string|nil
--- @param arg2 string|nil
--- @param arg3 string|nil
--- @param arg4 unknown|nil
--- @param arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineDebuffApply|nil
function BuffPipeline:TryDebuffApply(tracker, arg1, arg2, arg3, arg4, arg7, arg8)
    error("BuffPipeline:TryDebuffApply is abstract")
end

--- @param tracker DotTracker
--- @param arg1 string|nil
--- @param arg2 string|nil
--- @param arg3 string|nil
--- @param arg4 unknown|nil
--- @param arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineDotApply|nil
function BuffPipeline:TryDotApply(tracker, arg1, arg2, arg3, arg4, arg7, arg8)
    error("BuffPipeline:TryDotApply is abstract")
end

--- @param tracker SelfBuffTracker
--- @param event string
--- @param arg1 string|nil
--- @param arg3 string|nil
--- @param arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineSelfBuffUp|PipelineSelfBuffDown|nil
function BuffPipeline:TrySelfBuffMessage(tracker, event, arg1, arg3, arg7, arg8)
    error("BuffPipeline:TrySelfBuffMessage is abstract")
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
--- @param arg1 string|nil
--- @param arg3 string|nil
--- @param arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineDurationedSelfBuffUp|PipelineDurationedSelfBuffDown|nil
function BuffPipeline:TryDurationedSelfBuffMessage(tracker, event, arg1, arg3, arg7, arg8)
    error("BuffPipeline:TryDurationedSelfBuffMessage is abstract")
end

--- @param tracker EclipseTracker
--- @param event string
--- @param arg1 string|nil
--- @param arg3 string|nil
--- @param arg7 unknown|nil
--- @param arg8 unknown|nil
--- @return PipelineEclipseArcane|PipelineEclipseNature|PipelineEclipseClear|nil
function BuffPipeline:TryEclipseMessage(tracker, event, arg1, arg3, arg7, arg8)
    error("BuffPipeline:TryEclipseMessage is abstract")
end

function BuffPipeline:IsSelfSpellResistEvent(_event)
    return false
end

--- @param _arg1 string|nil
--- @param _abilityName string
--- @return string|nil
function BuffPipeline:TryAuraGoneOtherMobGuid(_arg1, _abilityName)
    error("BuffPipeline:TryAuraGoneOtherMobGuid is abstract")
end
