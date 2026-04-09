---@class PipelineSelfBuffUp : BuffPipelineMessage
PipelineSelfBuffUp = {}
PipelineSelfBuffUp.__index = PipelineSelfBuffUp

---@return PipelineSelfBuffUp
function PipelineSelfBuffUp.new()
    ---@type PipelineSelfBuffUp
    local self = {
        kind = BuffPipelineKind.BUFF_UP,
        t = "self_buff",
    }
    return setmetatable(self, PipelineSelfBuffUp)
end
