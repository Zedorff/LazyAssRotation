---@class PipelineDotResistLine : BuffPipelineMessage
---@field t "dot"
---@field line string|nil
PipelineDotResistLine = {}
PipelineDotResistLine.__index = PipelineDotResistLine

---@param line string|nil
---@return PipelineDotResistLine
function PipelineDotResistLine.new(line)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_RESIST_LINE)
    self.t = "dot"
    self.line = line
    return setmetatable(self, PipelineDotResistLine)
end
