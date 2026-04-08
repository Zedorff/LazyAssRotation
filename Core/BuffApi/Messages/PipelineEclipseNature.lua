---@class PipelineEclipseNature : BuffPipelineMessage
---@field t "eclipse"
---@field durationSec number
PipelineEclipseNature = {}
PipelineEclipseNature.__index = PipelineEclipseNature

---@param durationSec number
---@return PipelineEclipseNature
function PipelineEclipseNature.new(durationSec)
    local self = BuffPipelineMessage.new(BuffPipelineKind.ECLIPSE_NATURE)
    self.t = "eclipse"
    self.durationSec = durationSec
    return setmetatable(self, PipelineEclipseNature)
end
