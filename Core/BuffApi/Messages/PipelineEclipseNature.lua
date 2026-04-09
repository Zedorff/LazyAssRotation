---@class PipelineEclipseNature : BuffPipelineMessage
---@field durationSec number
PipelineEclipseNature = {}
PipelineEclipseNature.__index = PipelineEclipseNature

---@param durationSec number
---@return PipelineEclipseNature
function PipelineEclipseNature.new(durationSec)
    ---@type PipelineEclipseNature
    local self = {
        kind = BuffPipelineKind.ECLIPSE_NATURE,
        t = "eclipse",
        durationSec = durationSec,
    }
    return setmetatable(self, PipelineEclipseNature)
end
