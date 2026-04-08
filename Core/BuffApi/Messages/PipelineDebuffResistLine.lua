---@class PipelineDebuffResistLine : BuffPipelineMessage
---@field t "debuff"
---@field line string|nil
PipelineDebuffResistLine = {}
PipelineDebuffResistLine.__index = PipelineDebuffResistLine

---@param line string|nil
---@return PipelineDebuffResistLine
function PipelineDebuffResistLine.new(line)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_RESIST_LINE)
    self.t = "debuff"
    self.line = line
    return setmetatable(self, PipelineDebuffResistLine)
end
