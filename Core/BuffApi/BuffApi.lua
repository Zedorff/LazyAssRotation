--- @class BuffApi
BuffApi = {}

BuffApi.__index = BuffApi

--- @param tracker SelfBuffTracker
--- @param event string
function BuffApi:OnSelfBuffEvent(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    error("BuffApi:OnSelfBuffEvent is not implemented")
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
function BuffApi:OnDurationedSelfBuffEvent(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    error("BuffApi:OnDurationedSelfBuffEvent is not implemented")
end

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
function BuffApi:OnDebuffTrackerEvent(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    error("BuffApi:OnDebuffTrackerEvent is not implemented")
end

--- @param tracker DotTracker
--- @param now number
--- @param event string
function BuffApi:OnDotTrackerEvent(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    error("BuffApi:OnDotTrackerEvent is not implemented")
end

--- @param tracker WarlockDotTracker
--- @param now number
--- @param target string|nil
--- @param event string
function BuffApi:OnWarlockDotTrackerEvent(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    error("BuffApi:OnWarlockDotTrackerEvent is not implemented")
end
