---@class PipelineSelfBuffDown : BuffPipelineMessage
PipelineSelfBuffDown = {}
PipelineSelfBuffDown.__index = PipelineSelfBuffDown

---@return PipelineSelfBuffDown
function PipelineSelfBuffDown.new()
    ---@type PipelineSelfBuffDown
    local self = {
        kind = BuffPipelineKind.BUFF_DOWN,
        t = "self_buff",
    }
    return setmetatable(self, PipelineSelfBuffDown)
end
