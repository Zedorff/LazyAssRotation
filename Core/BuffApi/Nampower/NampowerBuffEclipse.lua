--- @class NampowerBuffEclipse : BuffEclipseHandler
--- @field pipeline NampowerBuffPipeline
NampowerBuffEclipse = {}
NampowerBuffEclipse.__index = NampowerBuffEclipse

--- @return NampowerBuffEclipse
function NampowerBuffEclipse.new()
    return setmetatable({ pipeline = NampowerBuffPipeline.new() }, NampowerBuffEclipse)
end

--- @param tracker EclipseTracker
--- @param event string
--- @param arg1 number|nil `AURA_CAST_ON_SELF`: spell id
--- @param arg3 string|nil `AURA_CAST_ON_SELF`: target unit guid; `BUFF_REMOVED_SELF`: spell id
--- @param arg7 unknown|nil `BUFF_REMOVED_SELF`: removal reason (`2` = refresh)
--- @param arg8 unknown|nil `AURA_CAST_ON_SELF`: duration (ms)
---@return BuffPipelineEclipseMessage|nil
function NampowerBuffEclipse:Message(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.pipeline:TryEclipseMessage(tracker, event, arg1, arg3, arg7, arg8)
end
