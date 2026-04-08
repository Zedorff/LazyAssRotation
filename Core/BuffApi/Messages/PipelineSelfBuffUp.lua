---@class PipelineSelfBuffUp : BuffPipelineMessage
---@field t "self_buff"
PipelineSelfBuffUp = {}
PipelineSelfBuffUp.__index = PipelineSelfBuffUp

---@return PipelineSelfBuffUp
function PipelineSelfBuffUp.new()
    local self = BuffPipelineMessage.new(BuffPipelineKind.BUFF_UP)
    self.t = "self_buff"
    return setmetatable(self, PipelineSelfBuffUp)
end
