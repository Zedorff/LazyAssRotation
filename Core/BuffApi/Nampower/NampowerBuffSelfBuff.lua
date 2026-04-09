--- @class NampowerBuffSelfBuff : BuffSelfBuffHandler
--- @field pipeline NampowerBuffPipeline
NampowerBuffSelfBuff = {}
NampowerBuffSelfBuff.__index = NampowerBuffSelfBuff

--- @return NampowerBuffSelfBuff
function NampowerBuffSelfBuff.new()
    return setmetatable({ pipeline = NampowerBuffPipeline.new() }, NampowerBuffSelfBuff)
end

--- @param tracker SelfBuffTracker
--- @param event string
--- @param arg1 number|nil `AURA_CAST_ON_SELF`: spell id
--- @param arg3 string|nil `AURA_CAST_ON_SELF`: target unit guid; `BUFF_REMOVED_SELF`: spell id
--- @param arg7 unknown|nil `BUFF_REMOVED_SELF`: removal reason (`2` = refresh)
---@return BuffPipelineSelfBuffMessage|nil
function NampowerBuffSelfBuff:SelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.pipeline:TrySelfBuffMessage(tracker, event, arg1, arg3, arg7, arg8)
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
--- @param arg1 number|nil `AURA_CAST_ON_SELF`: spell id
--- @param arg3 string|nil `AURA_CAST_ON_SELF`: target unit guid; `BUFF_REMOVED_SELF`: spell id
--- @param arg7 unknown|nil `BUFF_REMOVED_SELF`: removal reason (`2` = refresh)
--- @param arg8 unknown|nil `AURA_CAST_ON_SELF`: duration (ms)
---@return BuffPipelineDurationedSelfBuffMessage|nil
function NampowerBuffSelfBuff:DurationedSelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.pipeline:TryDurationedSelfBuffMessage(tracker, event, arg1, arg3, arg7, arg8)
end
