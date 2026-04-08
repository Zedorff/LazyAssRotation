---@class PipelineDotClearData : BuffPipelineMessage
---@field t "dot"
PipelineDotClearData = {}
PipelineDotClearData.__index = PipelineDotClearData

---@return PipelineDotClearData
function PipelineDotClearData.new()
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_CLEAR_DATA)
    self.t = "dot"
    return setmetatable(self, PipelineDotClearData)
end
