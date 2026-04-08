---@class PipelineWarlockDotResistLine : BuffPipelineMessage
---@field t "warlock_dot"
---@field line string|nil
PipelineWarlockDotResistLine = {}
PipelineWarlockDotResistLine.__index = PipelineWarlockDotResistLine

---@param line string|nil
---@return PipelineWarlockDotResistLine
function PipelineWarlockDotResistLine.new(line)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_RESIST_LINE)
    self.t = "warlock_dot"
    self.line = line
    return setmetatable(self, PipelineWarlockDotResistLine)
end
