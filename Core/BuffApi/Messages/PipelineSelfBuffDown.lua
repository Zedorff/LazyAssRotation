---@class PipelineSelfBuffDown : BuffPipelineMessage
---@field t "self_buff"
PipelineSelfBuffDown = {}
PipelineSelfBuffDown.__index = PipelineSelfBuffDown

---@return PipelineSelfBuffDown
function PipelineSelfBuffDown.new()
    local self = BuffPipelineMessage.new(BuffPipelineKind.BUFF_DOWN)
    self.t = "self_buff"
    return setmetatable(self, PipelineSelfBuffDown)
end
