---@class PipelineEclipseArcane : BuffPipelineMessage
---@field durationSec number
PipelineEclipseArcane = {}
PipelineEclipseArcane.__index = PipelineEclipseArcane

---@param durationSec number
---@return PipelineEclipseArcane
function PipelineEclipseArcane.new(durationSec)
    ---@type PipelineEclipseArcane
    local self = {
        kind = BuffPipelineKind.ECLIPSE_ARCANE,
        t = "eclipse",
        durationSec = durationSec,
    }
    return setmetatable(self, PipelineEclipseArcane)
end
