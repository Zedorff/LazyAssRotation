--- @class VanillaBuffEclipse : BuffEclipseHandler
--- @field pipeline VanillaBuffPipeline
VanillaBuffEclipse = {}
VanillaBuffEclipse.__index = VanillaBuffEclipse

--- @return VanillaBuffEclipse
function VanillaBuffEclipse.new()
    return setmetatable({ pipeline = VanillaBuffPipeline.new() }, VanillaBuffEclipse)
end

--- @param tracker EclipseTracker
--- @param event string
--- @param arg1 string|nil `CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS`: chat line; `CHAT_MSG_SPELL_AURA_GONE_SELF`: chat line
---@return BuffPipelineEclipseMessage|nil
function VanillaBuffEclipse:Message(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.pipeline:TryEclipseMessage(tracker, event, arg1, arg3, arg7, arg8)
end
