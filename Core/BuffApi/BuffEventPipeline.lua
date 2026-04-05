--- @class BuffEventPipeline
--- @field adapter VanillaBuffEventAdapter|NampowerBuffEventAdapter
BuffEventPipeline = {}
BuffEventPipeline.__index = BuffEventPipeline

--- @param adapter VanillaBuffEventAdapter|NampowerBuffEventAdapter
--- @return BuffEventPipeline
function BuffEventPipeline.new(adapter)
    --- @type BuffEventPipeline
    local self = { adapter = adapter }
    return setmetatable(self, BuffEventPipeline)
end

--- @param tracker SelfBuffTracker
--- @param event string
--- @param consume fun(msg: BuffPipelineSelfBuffMessage|nil)
function BuffEventPipeline:ApplySelfBuffEvent(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, consume)
    if BuffTrackerLifecycle.IsPlayerDeath(event) then
        consume(BuffTrackerLifecycle.SelfBuffSyntheticDeathMessage())
        return
    end
    --- @type BuffPipelineSelfBuffMessage|nil
    local msg = self.adapter:SelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    consume(msg)
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
--- @param consume fun(msg: BuffPipelineDurationedSelfBuffMessage|nil)
function BuffEventPipeline:ApplyDurationedSelfBuffEvent(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, consume)
    if BuffTrackerLifecycle.IsPlayerDeath(event) then
        consume(BuffTrackerLifecycle.DurationedSelfBuffSyntheticDeathMessage())
        return
    end
    --- @type BuffPipelineDurationedSelfBuffMessage|nil
    local msg = self.adapter:DurationedSelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    consume(msg)
end

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
--- @param consume fun(msg: BuffPipelineDebuffMessage|nil)
function BuffEventPipeline:ApplyDebuffEvent(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, consume)
    if BuffTrackerLifecycle.IsPlayerDeath(event) then
        consume(BuffTrackerLifecycle.DebuffSyntheticDeathMessage())
        return
    end
    --- @type BuffPipelineDebuffMessage|nil
    local msg = self.adapter:DebuffMessage(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    consume(msg)
end

--- @param tracker DotTracker
--- @param now number
--- @param event string
--- @param consume fun(msg: BuffPipelineDotMessage|nil)
function BuffEventPipeline:ApplyDotEvent(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, consume)
    if BuffTrackerLifecycle.IsPlayerDeath(event) then
        consume(BuffTrackerLifecycle.DotSyntheticDeathMessage())
        return
    end
    --- @type BuffPipelineDotMessage|nil
    local msg = self.adapter:DotMessage(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    consume(msg)
end

--- @param tracker WarlockDotTracker
--- @param now number
--- @param target string|nil
--- @param event string
--- @param consume fun(msg: BuffPipelineWarlockDotMessage|nil)
function BuffEventPipeline:ApplyWarlockDotEvent(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, consume)
    if BuffTrackerLifecycle.IsPlayerDeath(event) then
        consume(BuffTrackerLifecycle.WarlockDotSyntheticDeathMessage())
        return
    end
    --- @type BuffPipelineWarlockDotMessage|nil
    local msg = self.adapter:WarlockDotMessage(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    consume(msg)
end

--- @param tracker EclipseTracker
--- @param event string
--- @param consume fun(msg: BuffPipelineEclipseMessage|nil)
function BuffEventPipeline:ApplyEclipseEvent(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, consume)
    if BuffTrackerLifecycle.IsPlayerDeath(event) then
        consume(BuffTrackerLifecycle.EclipseSyntheticDeathMessage())
        return
    end
    --- @type BuffPipelineEclipseMessage|nil
    local msg = self.adapter:EclipseMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    consume(msg)
end
