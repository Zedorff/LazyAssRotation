---@class PipelineEclipseArcane : BuffPipelineMessage
---@field t "eclipse"
---@field durationSec number
PipelineEclipseArcane = {}
PipelineEclipseArcane.__index = PipelineEclipseArcane

---@param durationSec number
---@return PipelineEclipseArcane
function PipelineEclipseArcane.new(durationSec)
    local self = BuffPipelineMessage.new(BuffPipelineKind.ECLIPSE_ARCANE)
    self.t = "eclipse"
    self.durationSec = durationSec
    return setmetatable(self, PipelineEclipseArcane)
end
