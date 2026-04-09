---@class PipelineDurationedSelfBuffDown : BuffPipelineMessage
PipelineDurationedSelfBuffDown = {}
PipelineDurationedSelfBuffDown.__index = PipelineDurationedSelfBuffDown

---@return PipelineDurationedSelfBuffDown
function PipelineDurationedSelfBuffDown.new()
    ---@type PipelineDurationedSelfBuffDown
    local self = {
        kind = BuffPipelineKind.BUFF_DOWN,
        t = "durationed_self_buff",
    }
    return setmetatable(self, PipelineDurationedSelfBuffDown)
end
