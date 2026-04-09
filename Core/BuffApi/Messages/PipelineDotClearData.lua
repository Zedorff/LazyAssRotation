---@class PipelineDotClearData : BuffPipelineMessage
PipelineDotClearData = {}
PipelineDotClearData.__index = PipelineDotClearData

---@return PipelineDotClearData
function PipelineDotClearData.new()
    ---@type PipelineDotClearData
    local self = {
        kind = BuffPipelineKind.DEBUFF_CLEAR_DATA,
        t = "dot",
    }
    return setmetatable(self, PipelineDotClearData)
end
