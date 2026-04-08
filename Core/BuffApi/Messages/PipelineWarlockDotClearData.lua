---@class PipelineWarlockDotClearData : BuffPipelineMessage
---@field t "warlock_dot"
PipelineWarlockDotClearData = {}
PipelineWarlockDotClearData.__index = PipelineWarlockDotClearData

---@return PipelineWarlockDotClearData
function PipelineWarlockDotClearData.new()
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_CLEAR_DATA)
    self.t = "warlock_dot"
    return setmetatable(self, PipelineWarlockDotClearData)
end
