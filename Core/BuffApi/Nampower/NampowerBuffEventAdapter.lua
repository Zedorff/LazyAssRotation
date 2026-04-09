--- @class NampowerBuffEventAdapter
--- @field selfBuff NampowerBuffSelfBuff
--- @field debuff NampowerBuffDebuff
--- @field dot NampowerBuffDot
--- @field warlockDot NampowerBuffWarlockDot
--- @field eclipse NampowerBuffEclipse
NampowerBuffEventAdapter = {}
NampowerBuffEventAdapter.__index = NampowerBuffEventAdapter

--- @return NampowerBuffEventAdapter
function NampowerBuffEventAdapter.new()
    return setmetatable({
        selfBuff = NampowerBuffSelfBuff.new(),
        debuff = NampowerBuffDebuff.new(),
        dot = NampowerBuffDot.new(),
        warlockDot = NampowerBuffWarlockDot.new(),
        eclipse = NampowerBuffEclipse.new(),
    }, NampowerBuffEventAdapter)
end

--- @param tracker SelfBuffTracker
--- @param event string
--- @return BuffPipelineSelfBuffMessage|nil
function NampowerBuffEventAdapter:SelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.selfBuff:SelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
--- @return BuffPipelineDurationedSelfBuffMessage|nil
function NampowerBuffEventAdapter:DurationedSelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.selfBuff:DurationedSelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
--- @return BuffPipelineDebuffMessage|nil
function NampowerBuffEventAdapter:DebuffMessage(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.debuff:Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker DotTracker
--- @param now number
--- @param event string
--- @return BuffPipelineDotMessage|nil
function NampowerBuffEventAdapter:DotMessage(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.dot:Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker WarlockDotTracker
--- @param now number
--- @param target string|nil
--- @param event string
--- @return BuffPipelineWarlockDotMessage|nil
function NampowerBuffEventAdapter:WarlockDotMessage(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.warlockDot:Message(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker EclipseTracker
--- @param event string
--- @return BuffPipelineEclipseMessage|nil
function NampowerBuffEventAdapter:EclipseMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.eclipse:Message(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end
