---@class PipelineWarlockDotClearData : BuffPipelineMessage
PipelineWarlockDotClearData = {}
PipelineWarlockDotClearData.__index = PipelineWarlockDotClearData

---@return PipelineWarlockDotClearData
function PipelineWarlockDotClearData.new()
    ---@type PipelineWarlockDotClearData
    local self = {
        kind = BuffPipelineKind.DEBUFF_CLEAR_DATA,
        t = "warlock_dot",
    }
    return setmetatable(self, PipelineWarlockDotClearData)
end
