---@class PipelineDurationedSelfBuffDown : BuffPipelineMessage
---@field t "durationed_self_buff"
PipelineDurationedSelfBuffDown = {}
PipelineDurationedSelfBuffDown.__index = PipelineDurationedSelfBuffDown

---@return PipelineDurationedSelfBuffDown
function PipelineDurationedSelfBuffDown.new()
    local self = BuffPipelineMessage.new(BuffPipelineKind.BUFF_DOWN)
    self.t = "durationed_self_buff"
    return setmetatable(self, PipelineDurationedSelfBuffDown)
end
