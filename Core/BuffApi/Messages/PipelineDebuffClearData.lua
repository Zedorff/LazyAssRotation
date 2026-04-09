---@class PipelineDebuffClearData : BuffPipelineMessage
PipelineDebuffClearData = {}
PipelineDebuffClearData.__index = PipelineDebuffClearData

---@return PipelineDebuffClearData
function PipelineDebuffClearData.new()
    ---@type PipelineDebuffClearData
    local self = {
        kind = BuffPipelineKind.DEBUFF_CLEAR_DATA,
        t = "debuff",
    }
    return setmetatable(self, PipelineDebuffClearData)
end
