---@class PipelineDebuffResistLine : BuffPipelineMessage
---@field line string|nil
PipelineDebuffResistLine = {}
PipelineDebuffResistLine.__index = PipelineDebuffResistLine

---@param line string|nil
---@return PipelineDebuffResistLine
function PipelineDebuffResistLine.new(line)
    ---@type PipelineDebuffResistLine
    local self = {
        kind = BuffPipelineKind.DEBUFF_RESIST_LINE,
        t = "debuff",
        line = line,
    }
    return setmetatable(self, PipelineDebuffResistLine)
end
