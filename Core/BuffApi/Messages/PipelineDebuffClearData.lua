---@class PipelineDebuffClearData : BuffPipelineMessage
---@field t "debuff"
PipelineDebuffClearData = {}
PipelineDebuffClearData.__index = PipelineDebuffClearData

---@return PipelineDebuffClearData
function PipelineDebuffClearData.new()
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_CLEAR_DATA)
    self.t = "debuff"
    return setmetatable(self, PipelineDebuffClearData)
end
